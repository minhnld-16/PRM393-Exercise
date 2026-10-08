import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/artwork.dart';
import '../models/user.dart';

class GalleryStats {
  final int artworks;
  final int favorites;
  final int categories;
  const GalleryStats(this.artworks, this.favorites, this.categories);
}

class GalleryDatabase {
  GalleryDatabase._();
  static final GalleryDatabase instance = GalleryDatabase._();
  Database? _db;
  Future<Database> get database async => _db ??= await openDatabase(
    join(await getDatabasesPath(), 'art_gallery_manager.db'), version: 1,
    onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
    onCreate: (db, version) async {
      // Relationships: User 1:N Artwork; User N:M Artwork via Favorite.
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL UNIQUE,
          email TEXT NOT NULL,
          password TEXT NOT NULL,
          createdAt TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE artworks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          artist TEXT NOT NULL,
          year TEXT NOT NULL,
          category TEXT NOT NULL,
          description TEXT NOT NULL,
          createdBy INTEGER NOT NULL,
          FOREIGN KEY (createdBy) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
      await db.execute('''
        CREATE TABLE favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          artworkId INTEGER NOT NULL,
          createdAt TEXT NOT NULL,
          UNIQUE (userId, artworkId),
          FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
          FOREIGN KEY (artworkId) REFERENCES artworks(id) ON DELETE CASCADE
        )
      ''');
    },
  );

  Future<bool> usernameExists(String username) async =>
      (await (await database).query('users', columns: ['id'],
        where: 'username = ?', whereArgs: [username], limit: 1)).isNotEmpty;

  Future<int> register(String username, String email, String password) async =>
      (await database).insert('users', {
        'username': username, 'email': email, 'password': password,
        'createdAt': DateTime.now().toIso8601String(),
      });

  Future<GalleryUser?> authenticate(String username, String password) async {
    final rows = await (await database).query('users',
      where: 'username = ? AND password = ?', whereArgs: [username, password], limit: 1);
    return rows.isEmpty ? null : GalleryUser.fromMap(rows.first);
  }

  Future<GalleryUser?> userById(int userId) async {
    final rows = await (await database).query('users', where: 'id = ?',
      whereArgs: [userId], limit: 1);
    return rows.isEmpty ? null : GalleryUser.fromMap(rows.first);
  }

  Future<List<Artwork>> allArtworks() async {
    final rows = await (await database).query('artworks', orderBy: 'id DESC');
    return rows.map(Artwork.fromMap).toList();
  }

  Future<Artwork?> artworkById(int id) async {
    final rows = await (await database).query('artworks', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Artwork.fromMap(rows.first);
  }

  Future<int> addArtwork(Artwork artwork) async =>
      (await database).insert('artworks', artwork.toMap());

  Future<int> updateArtwork(Artwork artwork) async =>
      (await database).update('artworks', {
        'title': artwork.title, 'artist': artwork.artist, 'year': artwork.year,
        'category': artwork.category, 'description': artwork.description,
      }, where: 'id = ?', whereArgs: [artwork.id]);

  Future<int> deleteArtwork(int artworkId) async =>
      (await database).delete('artworks', where: 'id = ?', whereArgs: [artworkId]);

  Future<bool> isFavorite(int userId, int artworkId) async {
    final rows = await (await database).query('favorites', columns: ['id'],
      where: 'userId = ? AND artworkId = ?', whereArgs: [userId, artworkId], limit: 1);
    return rows.isNotEmpty;
  }

  Future<void> addFavorite(int userId, int artworkId) async {
    // Conflict avoidance prevents one user from favoriting an artwork twice.
    await (await database).insert('favorites', {
      'userId': userId, 'artworkId': artworkId,
      'createdAt': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> removeFavorite(int userId, int artworkId) async =>
      (await database).delete('favorites', where: 'userId = ? AND artworkId = ?',
        whereArgs: [userId, artworkId]);

  Future<List<Artwork>> favoriteArtworks(int userId) async {
    final rows = await (await database).rawQuery('''
      SELECT artworks.* FROM artworks
      INNER JOIN favorites ON favorites.artworkId = artworks.id
      WHERE favorites.userId = ? ORDER BY favorites.id DESC
    ''', [userId]);
    return rows.map(Artwork.fromMap).toList();
  }

  Future<GalleryStats> statistics(int userId) async {
    final db = await database;
    final artworkCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM artworks')) ?? 0;
    final favoriteCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM favorites WHERE userId = ?', [userId])) ?? 0;
    final categoryCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(DISTINCT category) FROM artworks')) ?? 0;
    return GalleryStats(artworkCount, favoriteCount, categoryCount);
  }
}
