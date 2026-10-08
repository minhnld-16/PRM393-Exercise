import 'package:flutter_test/flutter_test.dart';
import 'package:musicmanagerbasic_ce181159/models/song.dart';

void main() {
  test('Song defaults to not favorite', () {
    const song = Song(title: 'Test', artist: 'Artist', year: '2026', genre: 'Pop');
    expect(song.isFavorite, 0);
    final row = {...song.toMap(), 'id': 1};
    expect(Song.fromMap(row).id, 1);
    expect(Song.fromMap(row).isFavorite, 0);
  });
  test('Favorite toggle model update', () {
    const song = Song(id: 1, title: 'Test', artist: 'Artist', year: '2026', genre: 'Pop');
    expect(song.copyWith(isFavorite: 1).isFavorite, 1);
  });
}
