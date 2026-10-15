import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/song_database.dart';
import '../models/song.dart';
import 'login_screen.dart';
import 'song_detail_screen.dart';
import 'song_form_screen.dart';
import 'favorite_songs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> _songs = [];
  bool _loading = true;
  String _search = '';
  String _genre = 'All genres';
  String _year = 'All years';

  @override
  void initState() { super.initState(); _reload(); }

  Future<void> _reload() async {
    try {
      final songs = await SongDatabase.instance.allSongs();
      if (!mounted) return;
      setState(() {
        _songs = songs;
        if (_genre != 'All genres' && !songs.any((s) => s.genre == _genre)) _genre = 'All genres';
        _loading = false;
      });
    } catch (e) {
      if (mounted) { setState(() => _loading = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Database error: $e'))); }
    }
  }

  List<Song> get _visible {
    final now = DateTime.now().year;
    return _songs.where((s) {
      final matchesText = s.title.toLowerCase().contains(_search.toLowerCase()) || s.artist.toLowerCase().contains(_search.toLowerCase());
      final matchesGenre = _genre == 'All genres' || s.genre == _genre;
      final year = int.tryParse(s.year);
      final matchesYear = _year == 'All years' ||
          (_year == 'Current year' && year == now) ||
          (_year == 'Last 5 years' && year != null && year >= now - 4 && year <= now);
      return matchesText && matchesGenre && matchesYear;
    }).toList();
  }

  Future<void> _logout() async {
    await (await SharedPreferences.getInstance()).remove('isLogin');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (_) => const LoginScreen(loggedOut: true)), (_) => false);
  }

  Future<void> _open(Widget page) async {
    final result = await Navigator.push<Object?>(context, MaterialPageRoute(builder: (_) => page));
    if (!mounted) return;
    await _reload();
    if (mounted && result == 'deleted') ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Song deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    final genres = {'All genres', ..._songs.map((s) => s.genre)}.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: const Text('Music Library'), actions: [
        IconButton(tooltip: 'Favorite songs', onPressed: () => _open(const FavoriteSongsScreen()), icon: const Icon(Icons.favorite)),
        IconButton(tooltip: 'Logout', onPressed: _logout, icon: const Icon(Icons.logout)),
      ]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search title or artist', border: OutlineInputBorder()),
          onChanged: (v) => setState(() => _search = v),
        )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: [
          Expanded(child: DropdownButtonFormField<String>(value: _genre, isExpanded: true,
            decoration: const InputDecoration(labelText: 'Genre', border: OutlineInputBorder()),
            items: genres.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (s) => setState(() => _genre = s ?? 'All genres'))),
          const SizedBox(width: 10),
          Expanded(child: DropdownButtonFormField<String>(value: _year,
            decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder()),
            items: ['All years','Current year','Last 5 years'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (s) => setState(() => _year = s ?? 'All years'))),
        ])),
        const SizedBox(height: 12),
        Expanded(child: _loading ? const Center(child: CircularProgressIndicator()) :
          _visible.isEmpty ? const Center(child: Text('No songs found')) :
          ListView.builder(itemCount: _visible.length, itemBuilder: (context, index) {
            final song = _visible[index];
            return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.music_note)), title: Text(song.title),
              subtitle: Text('${song.artist} • ${song.year}'),
              trailing: Icon(song.isFavorite == 1 ? Icons.favorite : Icons.chevron_right,
                  color: song.isFavorite == 1 ? Colors.red : null),
              onTap: () => _open(SongDetailScreen(songId: song.id!)),
            ));
          })),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _open(const SongFormScreen()),
        label: const Text('Add Song'), icon: const Icon(Icons.add)),
    );
  }
}
