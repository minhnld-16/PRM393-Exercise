class GalleryUser {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String createdAt;
  const GalleryUser({this.id, required this.username, required this.email,
    required this.password, required this.createdAt});
  factory GalleryUser.fromMap(Map<String, Object?> m) => GalleryUser(
    id: m['id'] as int, username: m['username'] as String,
    email: m['email'] as String, password: m['password'] as String,
    createdAt: m['createdAt'] as String,
  );
}
