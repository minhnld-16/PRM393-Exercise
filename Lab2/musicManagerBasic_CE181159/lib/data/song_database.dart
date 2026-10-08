import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/song.dart';

class SongDatabase {
  SongDatabase._();
  static final SongDatabase instance = SongDatabase._();
  Database? _database;

  Future<Database> get database async => _database ??= await openDatabase(
    join(await getDatabasesPath(), 'music_manager.db'),
    version: 1,
    onCreate: (db, version) async {
      // Lab 2 explicitly permits ONE table only; there are no user/favorite tables.
      await db.execute('''
        CREATE TABLE Song (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          artist TEXT NOT NULL,
          year TEXT NOT NULL,
          genre TEXT NOT NULL,
          isFavorite INTEGER NOT NULL DEFAULT 0
          CHECK (isFavorite IN (0, 1))
        )
      ''');
    },
  );

  Future<List<Song>> allSongs() async {
    final db = await database;
    return (await db.query('Song', orderBy: 'id DESC')).map(Song.fromMap).toList();
  }

  Future<Song?> songById(int id) async {
    final rows = await (await database).query('Song', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Song.fromMap(rows.first);
  }

  Future<void> insertSong(Song song) async {
    await (await database).insert('Song', song.toMap());
  }

  Future<void> updateSong(Song song) async {
    await (await database).update('Song', song.toMap(), where: 'id = ?', whereArgs: [song.id]);
  }

  Future<void> deleteSong(int id) async {
    await (await database).delete('Song', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleFavorite(Song song) async {
    await (await database).update('Song', {'isFavorite': song.isFavorite == 1 ? 0 : 1},
        where: 'id = ?', whereArgs: [song.id]);
  }

  Future<List<Song>> favoriteSongs() async {
    final rows = await (await database).query('Song', where: 'isFavorite = ?',
        whereArgs: [1], orderBy: 'id DESC');
    return rows.map(Song.fromMap).toList();
  }
}
