import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5/app.dart';
import 'package:lab5/data/local/app_database.dart';
import 'package:lab5/data/models/shopping_item.dart';
import 'package:lab5/data/repositories/shopping_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  testWidgets(
    'Windows SQLite: add, validate, wishlist total, toggle, delete, persistence',
    (tester) async {
      final previousShadows = debugDisableShadows;
      debugDisableShadows = false;
      try {
        final temporary = await tester.runAsync(() async {
          final fonts = Platform.environment['WINDIR'];
          if (fonts != null) {
            final loader = FontLoader('Roboto');
            loader.addFont(
              File(
                '$fonts/Fonts/arial.ttf',
              ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
            );
            await loader.load();
          }
          final icons = FontLoader('MaterialIcons')
            ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
          await icons.load();
          final directory = await Directory.systemTemp.createTemp('lab5_qc_');
          await AppDatabase.initialize(databaseDirectory: directory.path);
          return directory;
        });
        tester.view.physicalSize = const Size(390, 740);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final boundary = GlobalKey();
        Future<void> settle() async {
          // SQLite FFI runs outside the fake test clock.
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 150)),
          );
          await tester.pumpAndSettle();
        }

        Future<void> capture(String name) async {
          await tester.pump();
          await tester.runAsync(() async {
            final render =
                boundary.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            final image = await render.toImage();
            final data = await image.toByteData(format: ui.ImageByteFormat.png);
            final file = File('build/qc/$name.png');
            await file.parent.create(recursive: true);
            await file.writeAsBytes(data!.buffer.asUint8List());
            image.dispose();
          });
        }

        await tester.pumpWidget(
          RepaintBoundary(key: boundary, child: const FavoriteShoppingApp()),
        );
        await settle();
        expect(find.text('Chưa có sản phẩm nào'), findsOneWidget);
        await capture('home_empty');
        await tester.tap(find.byType(FloatingActionButton));
        await settle();
        await tester.tap(find.text('Cancel'));
        await settle();
        expect(find.text('Favorite Shopping Items'), findsOneWidget);
        await tester.tap(find.byType(FloatingActionButton));
        await settle();
        await capture('add');
        await tester.tap(find.text('Save'));
        await settle();
        expect(find.text('Error'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text('Please enter item name'),
          ),
          findsOneWidget,
        );
        await capture('validation');
        await tester.tap(find.text('OK'));
        await settle();
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'Nike Air Force 1',
        );
        await tester.enterText(find.byType(TextFormField).at(1), '2500000');
        await tester.tap(find.text('Save'));
        await settle();
        expect(find.text('Success'), findsOneWidget);
        expect(
          find.text('Added "Nike Air Force 1" to wishlist'),
          findsOneWidget,
        );
        await tester.tap(find.text('OK'));
        await settle();
        final repository = ShoppingRepository.instance;
        await tester.runAsync(
          () => repository.add(
            const ShoppingItem(
              itemName: 'Apple AirPods Pro 2',
              category: 'Electronics',
              price: 5600000,
            ),
          ),
        );
        await tester.runAsync(
          () => repository.add(
            const ShoppingItem(
              itemName: 'Adidas Ultraboost 23',
              category: 'Fashion',
              price: 4200000,
              status: ShoppingStatus.purchased,
            ),
          ),
        );
        // Rebuild the shell to simulate a new application session with saved data.
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(
          RepaintBoundary(key: boundary, child: const FavoriteShoppingApp()),
        );
        await settle();
        await capture('home_items');
        await tester.tap(find.text('Wishlist').last);
        await settle();
        expect(find.text('8.100.000 ₫'), findsOneWidget);
        expect(find.text('Adidas Ultraboost 23'), findsNothing);
        await capture('wishlist');
        await tester.tap(find.text('Nike Air Force 1'));
        await settle();
        await capture('detail');
        await tester.tap(find.text('Mark Purchased'));
        await settle();
        expect(
          await tester
              .runAsync(() => repository.getWishlist())
              .then((items) => items!.length),
          1,
        );
        await tester.tap(find.text('Move to Wishlist'));
        await settle();
        await tester.tap(find.text('Delete'));
        await settle();
        expect(find.text('Confirm Delete'), findsOneWidget);
        await capture('confirm_delete');
        await tester.tap(find.text('CANCEL'));
        await settle();
        expect(
          await tester
              .runAsync(() => repository.getAll())
              .then((items) => items!.length),
          3,
        );
        await tester.tap(find.text('Delete'));
        await settle();
        await tester.tap(find.text('DELETE'));
        await settle();
        expect(find.text('Item deleted'), findsOneWidget);
        await tester.tap(find.text('OK'));
        await settle();
        expect(find.text('5.600.000 ₫'), findsNWidgets(2));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(() async {
          final db = await AppDatabase.instance.database;
          final path = db.path;
          await db.close();
          final reopened = await databaseFactory.openDatabase(path);
          final rows = await reopened.query(AppDatabase.table);
          expect(rows.length, 2);
          expect(
            rows.any((row) => row['itemName'] == 'Nike Air Force 1'),
            isFalse,
          );
          await reopened.close();
          await temporary!.delete(recursive: true);
        });
      } finally {
        debugDisableShadows = previousShadows;
      }
    },
  );
}
