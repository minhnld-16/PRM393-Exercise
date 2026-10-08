import 'package:flutter/material.dart';
import '../data/gallery_database.dart';
import '../models/artwork.dart';
import 'artwork_detail_screen.dart';

class FavoriteArtworksScreen extends StatefulWidget {
  final int userId;
  const FavoriteArtworksScreen({super.key, required this.userId});
  @override
  State<FavoriteArtworksScreen> createState() => _FavoriteArtworksScreenState();
}

class _FavoriteArtworksScreenState extends State<FavoriteArtworksScreen> {
  List<Artwork> _artworks = [];
  bool _loading = true;
  @override
  void initState() { super.initState(); _reload(); }

  Future<void> _reload() async {
    final artworks = await GalleryDatabase.instance.favoriteArtworks(widget.userId);
    if (mounted) setState(() { _artworks = artworks; _loading = false; });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favorite Artworks')),
    body: _loading ? const Center(child: CircularProgressIndicator()) :
      _artworks.isEmpty ? const Center(child: Text('No favorite artworks')) :
      ListView.builder(itemCount: _artworks.length, itemBuilder: (context, i) {
        final artwork = _artworks[i];
        return Card(child: ListTile(title: Text(artwork.title),
          subtitle: Text('${artwork.artist} • ${artwork.year}'),
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) =>
              ArtworkDetailScreen(userId: widget.userId, artworkId: artwork.id!)));
            await _reload();
          },
          trailing: IconButton(icon: const Icon(Icons.favorite, color: Colors.red),
            tooltip: 'Remove from favorites', onPressed: () async {
              await GalleryDatabase.instance.removeFavorite(widget.userId, artwork.id!);
              await _reload();
            }),
        ));
      }),
  );
}
