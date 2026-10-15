import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A single database is shared by every screen. No network is required.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const table = 'shopping_items';
  static Future<void> initialize({String? databaseDirectory}) async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      final localAppData = Platform.environment['LOCALAPPDATA'];
      final directory =
          databaseDirectory ??
          (Platform.isWindows && localAppData != null
              ? p.join(localAppData, 'Lab5', 'FavoriteShoppingItems')
              : null);
      if (directory != null) {
        await databaseFactory.setDatabasesPath(directory);
      }
    }
  }

  Future<Database>? _opening;

  Future<Database> get database => _opening ??= _open();

  Future<Database> _open() async {
    final directory = await getDatabasesPath();
    return openDatabase(
      p.join(directory, 'favorite_shopping_items.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT NOT NULL,
            category TEXT NOT NULL,
            price REAL NOT NULL CHECK(price > 0),
            status TEXT NOT NULL DEFAULT 'Wishlist'
              CHECK(status IN ('Wishlist', 'Purchased'))
          )
        ''');
      },
    );
  }
}
