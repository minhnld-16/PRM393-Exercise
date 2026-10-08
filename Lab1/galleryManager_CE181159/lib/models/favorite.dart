class Favorite {
  final int? id;
  final int userId;
  final int artworkId;
  final String createdAt;
  const Favorite({this.id, required this.userId, required this.artworkId,
    required this.createdAt});
  factory Favorite.fromMap(Map<String, Object?> m) => Favorite(
    id: m['id'] as int, userId: m['userId'] as int,
    artworkId: m['artworkId'] as int, createdAt: m['createdAt'] as String,
  );
}
