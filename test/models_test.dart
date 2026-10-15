import 'package:flutter_test/flutter_test.dart';
import 'package:gallerymanager_ce181159/models/artwork.dart';
import 'package:gallerymanager_ce181159/models/user.dart';
import 'package:gallerymanager_ce181159/models/favorite.dart';

void main() {
  test('Artwork model matches the database field names', () {
    final artwork = Artwork(id: 7, title: 'Sunrise', artist: 'An', year: '2026',
        category: 'Landscape', description: 'Sea', createdBy: 3);
    final row = {...artwork.toMap(), 'id': 7};
    expect(Artwork.fromMap(row).title, 'Sunrise');
    expect(Artwork.fromMap(row).createdBy, 3);
    expect(artworkCategories, contains('Portrait'));
  });
  test('User and Favorite models preserve ID links', () {
    final user = GalleryUser.fromMap({'id': 3, 'username': 'member',
      'email': 'member@example.com', 'password': 'pw', 'createdAt': '2026-10-09'});
    final fav = Favorite.fromMap({'id': 12, 'userId': 3,
      'artworkId': 7, 'createdAt': '2026-10-09'});
    expect(fav.userId, user.id);
    expect(fav.artworkId, 7);
  });
}
