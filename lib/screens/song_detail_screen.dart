import 'package:flutter/material.dart';
import '../data/song_database.dart';
import '../models/song.dart';
import 'song_form_screen.dart';

class SongDetailScreen extends StatefulWidget {
  final int songId;
  const SongDetailScreen({super.key, required this.songId});
  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  Song? _song;
  bool _loading = true;
  @override
  void initState() { super.initState(); _reload(); }
  Future<void> _reload() async {
    final song = await SongDatabase.instance.songById(widget.songId);
    if (mounted) setState(() { _song = song; _loading = false; });
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Delete Song'), content: const Text('Are you sure you want to delete this song?'),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))],
    ));
    if (confirmed != true) return;
    await SongDatabase.instance.deleteSong(widget.songId);
    if (mounted) Navigator.pop(context, 'deleted');
  }

  @override
  Widget build(BuildContext context) {
    final song = _song;
    return Scaffold(appBar: AppBar(title: const Text('Song Detail')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : song == null ? const Center(child: Text('Song not found')) :
      ListView(padding: const EdgeInsets.all(20), children: [
        const Center(child: Icon(Icons.music_note, size: 70, color: Colors.deepPurple)),
        const SizedBox(height: 12),
        Text(song.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        ListTile(title: const Text('Artist'), subtitle: Text(song.artist)),
        ListTile(title: const Text('Year'), subtitle: Text(song.year)),
        ListTile(title: const Text('Genre'), subtitle: Text(song.genre)),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => SongFormScreen(song: song)));
          await _reload();
        }, icon: const Icon(Icons.edit), label: const Text('Edit Song')),
        OutlinedButton.icon(onPressed: _delete, icon: const Icon(Icons.delete), label: const Text('Delete Song')),
        FilledButton.tonalIcon(onPressed: () async {
          await SongDatabase.instance.toggleFavorite(song);
          await _reload();
        }, icon: Icon(song.isFavorite == 1 ? Icons.favorite : Icons.favorite_border),
           label: Text(song.isFavorite == 1 ? 'Remove Favorite' : 'Add to Favorite')),
      ]),
    );
  }
}
