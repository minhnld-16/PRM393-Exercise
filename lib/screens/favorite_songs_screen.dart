import 'package:flutter/material.dart';
import '../data/song_database.dart';
import '../models/song.dart';
import 'song_detail_screen.dart';

class FavoriteSongsScreen extends StatefulWidget {
  const FavoriteSongsScreen({super.key});
  @override
  State<FavoriteSongsScreen> createState() => _FavoriteSongsScreenState();
}

class _FavoriteSongsScreenState extends State<FavoriteSongsScreen> {
  List<Song> _favorites = [];
  bool _loading = true;
  @override
  void initState() { super.initState(); _reload(); }
  Future<void> _reload() async {
    final favorites = await SongDatabase.instance.favoriteSongs();
    if (mounted) setState(() { _favorites = favorites; _loading = false; });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favorite Songs')),
    body: _loading ? const Center(child: CircularProgressIndicator()) :
      _favorites.isEmpty ? const Center(child: Text('No favorite songs')) :
      ListView.builder(itemCount: _favorites.length, itemBuilder: (context, index) {
        final song = _favorites[index];
        return ListTile(title: Text(song.title), subtitle: Text('${song.artist} • ${song.year}'),
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => SongDetailScreen(songId: song.id!)));
            await _reload();
          },
          trailing: IconButton(tooltip: 'Remove from favorites', icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () async { await SongDatabase.instance.toggleFavorite(song); await _reload(); }),
        );
      }),
  );
}
