import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:recurring_bills_manager/data/bill_database.dart';
import 'package:recurring_bills_manager/models/bill.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Desktop SQLite persists bills and supports CRUD and unpaid filtering',
      () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final directory = await Directory.systemTemp.createTemp('bills_database_');
    await databaseFactory.setDatabasesPath(directory.path);
    final bills = BillDatabase.instance;
    final database = await bills.database;
    try {
      expect(await bills.allBills(), isEmpty);
      final id = await bills.add(Bill(
        billName: 'Electricity',
        category: 'Utilities',
        amount: 850000,
        status: 'Unpaid',
        dueDate: '2026-10-30',
      ));
      expect((await bills.unpaidBills()).single.id, id);
      final saved = await databaseFactory.openDatabase(
        database.path,
        options: OpenDatabaseOptions(singleInstance: false, readOnly: true),
      );
      try {
        expect((await saved.query('bills')).single['bill_name'], 'Electricity');
      } finally {
        await saved.close();
      }
      await bills.update(Bill(
        id: id,
        billName: 'Electricity',
        category: 'Utilities',
        amount: 850000,
        status: 'Paid',
        dueDate: '2026-10-30',
      ));
      expect(await bills.unpaidBills(), isEmpty);
      expect((await bills.allBills()).single.status, 'Paid');
      await bills.delete(id);
      expect(await bills.allBills(), isEmpty);
    } finally {
      await database.close();
      await directory.delete(recursive: true);
    }
  });
}
