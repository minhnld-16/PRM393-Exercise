import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/bills_home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final supportDirectory = await getApplicationSupportDirectory();
    await databaseFactory.setDatabasesPath(
      p.join(supportDirectory.path, 'databases'),
    );
  }
  runApp(const RecurringBillsApp());
}

class RecurringBillsApp extends StatelessWidget {
  const RecurringBillsApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Recurring Bills Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff8000ff)),
          scaffoldBackgroundColor: const Color(0xfff5f5f5),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xffe0e0e0)),
            ),
            hintStyle: const TextStyle(color: Color(0xffb0b0b0), fontSize: 13),
          ),
          textButtonTheme: TextButtonThemeData(
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xff1683da)),
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))),
            titleTextStyle: TextStyle(
                color: Color(0xff222222),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        builder: (context, child) => ColoredBox(
          color: const Color(0xffeaeaea),
          child: Center(
              child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: child!,
          )),
        ),
        home: const BillsHomeScreen(),
      );
}
