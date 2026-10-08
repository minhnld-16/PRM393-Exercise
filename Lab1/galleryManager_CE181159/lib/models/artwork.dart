class Artwork {
  final int? id;
  final String title;
  final String artist;
  final String year;
  final String category;
  final String description;
  final int createdBy;

  const Artwork({this.id, required this.title, required this.artist,
    required this.year, required this.category, required this.description,
    required this.createdBy});

  factory Artwork.fromMap(Map<String, Object?> m) => Artwork(
    id: m['id'] as int, title: m['title'] as String, artist: m['artist'] as String,
    year: m['year'] as String, category: m['category'] as String,
    description: m['description'] as String, createdBy: m['createdBy'] as int,
  );

  Map<String, Object?> toMap() => {
    'title': title, 'artist': artist, 'year': year,
    'category': category, 'description': description, 'createdBy': createdBy,
  };
}

const artworkCategories = ['Abstract', 'Realism', 'Landscape', 'Portrait'];
