import 'package:flutter/material.dart';
import '../data/gallery_database.dart';
import '../models/artwork.dart';
import 'artwork_form_screen.dart';

class ArtworkDetailScreen extends StatefulWidget {
  final int artworkId;
  final int userId;
  const ArtworkDetailScreen({super.key, required this.artworkId, required this.userId});
  @override
  State<ArtworkDetailScreen> createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  Artwork? _artwork;
  bool _favorite = false;
  bool _loading = true;
  @override
  void initState() { super.initState(); _reload(); }

  Future<void> _reload() async {
    final db = GalleryDatabase.instance;
    final artwork = await db.artworkById(widget.artworkId);
    final favorite = artwork == null ? false : await db.isFavorite(widget.userId, widget.artworkId);
    if (mounted) setState(() { _artwork = artwork; _favorite = favorite; _loading = false; });
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Delete Artwork'),
      content: const Text('Are you sure you want to delete this artwork?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
      ],
    ));
    if (confirmed != true) return;
    try {
      await GalleryDatabase.instance.deleteArtwork(widget.artworkId);
      if (mounted) Navigator.pop(context, 'Artwork deleted successfully');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  Future<void> _favoriteArtwork() async {
    if (_favorite) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Already in favorites')));
      return;
    }
    await GalleryDatabase.instance.addFavorite(widget.userId, widget.artworkId);
    await _reload();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to favorites')));
  }

  @override
  Widget build(BuildContext context) {
    final a = _artwork;
    return Scaffold(appBar: AppBar(title: const Text('Artwork Detail')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : a == null ?
      const Center(child: Text('Artwork no longer exists')) :
      ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
          color: Colors.teal.shade600, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('${a.artist} • ${a.year} • ${a.category}', style: const TextStyle(color: Colors.white)),
          ])),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Artist: ${a.artist}'), const SizedBox(height: 8),
            Text('Year: ${a.year}'), const SizedBox(height: 8),
            Text('Category: ${a.category}'), const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6), Text(a.description),
          ]))),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: () async {
          final msg = await Navigator.push<String>(context, MaterialPageRoute(
            builder: (_) => ArtworkFormScreen(userId: widget.userId, artwork: a)));
          await _reload();
          if (mounted && msg != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }, icon: const Icon(Icons.edit), label: const Text('Edit Artwork')),
        OutlinedButton.icon(onPressed: _delete, icon: const Icon(Icons.delete), label: const Text('Delete Artwork')),
        FilledButton.tonalIcon(onPressed: _favoriteArtwork,
          icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border),
          label: Text(_favorite ? 'Already Favorite' : 'Add to Favorite')),
      ]),
    );
  }
}
