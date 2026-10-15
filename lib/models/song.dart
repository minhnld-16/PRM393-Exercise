class Song {
  final int? id;
  final String title;
  final String artist;
  final String year;
  final String genre;
  final int isFavorite;

  const Song({this.id, required this.title, required this.artist, required this.year,
    required this.genre, this.isFavorite = 0});

  factory Song.fromMap(Map<String, Object?> map) => Song(
    id: map['id'] as int,
    title: map['title'] as String,
    artist: map['artist'] as String,
    year: map['year'] as String,
    genre: map['genre'] as String,
    isFavorite: map['isFavorite'] as int,
  );

  Map<String, Object?> toMap() => {
    'title': title, 'artist': artist, 'year': year,
    'genre': genre, 'isFavorite': isFavorite,
  };

  Song copyWith({int? isFavorite}) => Song(id: id, title: title, artist: artist,
    year: year, genre: genre, isFavorite: isFavorite ?? this.isFavorite);
}
