import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/gallery_database.dart';
import '../models/artwork.dart';
import '../models/user.dart';
import 'artwork_detail_screen.dart';
import 'artwork_form_screen.dart';
import 'favorite_artworks_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({super.key, required this.userId});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Artwork> _artworks = [];
  GalleryStats _stats = const GalleryStats(0, 0, 0);
  GalleryUser? _user;
  bool _loading = true;
  String _query = '';
  String _category = 'All Categories';
  String _year = 'All years';

  @override
  void initState() { super.initState(); _reload(); }

  Future<void> _reload() async {
    try {
      final db = GalleryDatabase.instance;
      final all = await db.allArtworks();
      final stats = await db.statistics(widget.userId);
      final user = await db.userById(widget.userId);
      if (mounted) setState(() {
        _artworks = all; _stats = stats; _user = user; _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Database error: $e')));
      }
    }
  }

  List<Artwork> get _filtered {
    final now = DateTime.now().year;
    return _artworks.where((a) {
      final y = int.tryParse(a.year);
      return a.title.toLowerCase().contains(_query.toLowerCase()) &&
        (_category == 'All Categories' || a.category == _category) &&
        (_year == 'All years' ||
          (_year == 'Current year' && y == now) ||
          (_year == 'Last 5 years' && y != null && y >= now - 4 && y <= now));
    }).toList();
  }

  Future<void> _go(Widget page) async {
    final result = await Navigator.push<Object?>(context, MaterialPageRoute(builder: (_) => page));
    if (!mounted) return;
    await _reload();
    if (mounted && result is String) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }

  Future<void> _logout() async {
    await (await SharedPreferences.getInstance()).remove('galleryUserId');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute<void>(builder: (_) => const LoginScreen(loggedOut: true)), (_) => false);
  }

  Widget _stat(String label, int value, IconData icon) => Expanded(child: Card(
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Column(children: [Icon(icon, color: Colors.teal), const SizedBox(height: 6),
        Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))]))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery Dashboard'), actions: [
        IconButton(tooltip: 'Favorite Artworks', icon: const Icon(Icons.favorite_border),
          onPressed: () => _go(FavoriteArtworksScreen(userId: widget.userId))),
        IconButton(tooltip: 'Logout', icon: const Icon(Icons.logout), onPressed: _logout),
      ]),
      body: _loading ? const Center(child: CircularProgressIndicator()) :
        Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(12, 4, 12, 8), child: ClipRRect(
            borderRadius: BorderRadius.circular(15), child: Image.asset('assets/images/banner.png',
              height: 106, fit: BoxFit.cover, width: double.infinity))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Card(color: Colors.teal.shade50,
            child: ListTile(leading: const Icon(Icons.museum), title: const Text('Gallery Collection'),
              subtitle: Text('Welcome back, ${_user?.username ?? ''}')))),
          Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 0), child:
            Row(children: [_stat('Artworks', _stats.artworks, Icons.image),
              _stat('Favorites', _stats.favorites, Icons.favorite_border),
              _stat('Categories', _stats.categories, Icons.category)])),
          Padding(padding: const EdgeInsets.all(12), child: TextField(
            decoration: const InputDecoration(labelText: 'Search by title', border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search)),
            onChanged: (text) => setState(() => _query = text),
          )),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: [
            Expanded(child: DropdownButtonFormField<String>(value: _year, isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Year Filter'),
              items: ['All years', 'Current year', 'Last 5 years'].map((value) =>
                DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (v) => setState(() => _year = v ?? 'All years'))),
            const SizedBox(width: 8),
            Expanded(child: DropdownButtonFormField<String>(value: _category, isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Category'),
              items: ['All Categories', ...artworkCategories].map((value) =>
                DropdownMenuItem(value: value, child: Text(value, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (v) => setState(() => _category = v ?? 'All Categories'))),
          ])),
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Align(
            alignment: Alignment.centerLeft, child: Text('Artwork Collection (${_filtered.length})',
            style: Theme.of(context).textTheme.titleMedium))),
          Expanded(child: _filtered.isEmpty ? const Center(child: Text('No artworks found')) :
            ListView.builder(itemCount: _filtered.length, itemBuilder: (context, index) {
              final artwork = _filtered[index];
              return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: ListTile(leading: const CircleAvatar(child: Icon(Icons.palette)),
                  title: Text(artwork.title), subtitle: Text('${artwork.artist} • ${artwork.year}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _go(ArtworkDetailScreen(artworkId: artwork.id!, userId: widget.userId))));
            })),
        ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _go(ArtworkFormScreen(userId: widget.userId)),
        icon: const Icon(Icons.add), label: const Text('Add Artwork')),
    );
  }
}
