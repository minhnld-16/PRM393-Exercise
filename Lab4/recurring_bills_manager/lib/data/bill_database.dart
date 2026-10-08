import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bill.dart';

class BillDatabase {
  BillDatabase._();
  static final BillDatabase instance = BillDatabase._();
  Database? _db;

  Future<Database> get database async => _db ??= await openDatabase(
    join(await getDatabasesPath(), 'recurring_bills.db'),
    version: 1,
    onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE bills (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          bill_name TEXT NOT NULL,
          category TEXT NOT NULL,
          amount REAL NOT NULL,
          status TEXT NOT NULL CHECK (status IN ('Paid', 'Unpaid')),
          due_date TEXT NOT NULL
        )
      ''');
    },
  );

  Future<List<Bill>> allBills() async {
    final rows = await (await database).query('bills', orderBy: 'due_date ASC, id ASC');
    return rows.map(Bill.fromMap).toList();
  }

  Future<List<Bill>> unpaidBills() async {
    final rows = await (await database).query('bills', where: 'status = ?',
        whereArgs: ['Unpaid'], orderBy: 'due_date ASC, id ASC');
    return rows.map(Bill.fromMap).toList();
  }

  Future<int> add(Bill bill) async => (await database).insert('bills', bill.toMap());
  Future<int> update(Bill bill) async => (await database).update('bills', bill.toMap(),
      where: 'id = ?', whereArgs: [bill.id]);
  Future<int> delete(int id) async => (await database).delete('bills', where: 'id = ?', whereArgs: [id]);
}
