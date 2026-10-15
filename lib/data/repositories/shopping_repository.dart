import 'package:lab5/data/local/app_database.dart';
import 'package:lab5/data/models/shopping_item.dart';

class ShoppingRepository {
  ShoppingRepository._();
  static final ShoppingRepository instance = ShoppingRepository._();

  Future<List<ShoppingItem>> getAll() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(AppDatabase.table, orderBy: 'id DESC');
    return rows.map(ShoppingItem.fromMap).toList();
  }

  Future<List<ShoppingItem>> getWishlist() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      AppDatabase.table,
      where: 'status = ?',
      whereArgs: [ShoppingStatus.wishlist.value],
      orderBy: 'id DESC',
    );
    return rows.map(ShoppingItem.fromMap).toList();
  }

  Future<int> add(ShoppingItem item) async {
    final db = await AppDatabase.instance.database;
    return db.insert(AppDatabase.table, item.toMap());
  }

  Future<void> setStatus(int id, ShoppingStatus status) async {
    final db = await AppDatabase.instance.database;
    final updated = await db.update(
      AppDatabase.table,
      {'status': status.value},
      where: 'id = ?',
      whereArgs: [id],
    );
    if (updated != 1) throw StateError('Item not found: $id');
  }

  Future<void> delete(int id) async {
    final db = await AppDatabase.instance.database;
    final removed = await db.delete(
      AppDatabase.table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (removed != 1) throw StateError('Item not found: $id');
  }
}
