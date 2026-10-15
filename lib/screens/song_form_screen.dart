import 'package:flutter/material.dart';
import '../data/song_database.dart';
import '../models/song.dart';

class SongFormScreen extends StatefulWidget {
  final Song? song;
  const SongFormScreen({super.key, this.song});
  @override
  State<SongFormScreen> createState() => _SongFormScreenState();
}

class _SongFormScreenState extends State<SongFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title, _artist, _year, _genre;
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.song?.title ?? '');
    _artist = TextEditingController(text: widget.song?.artist ?? '');
    _year = TextEditingController(text: widget.song?.year ?? '');
    _genre = TextEditingController(text: widget.song?.genre ?? '');
  }
  @override
  void dispose() { for (final c in [_title, _artist, _year, _genre]) { c.dispose(); } super.dispose(); }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final song = Song(id: widget.song?.id, title: _title.text.trim(),
      artist: _artist.text.trim(), year: _year.text.trim(), genre: _genre.text.trim(),
      isFavorite: widget.song?.isFavorite ?? 0);
    try {
      if (widget.song == null) { await SongDatabase.instance.insertSong(song); }
      else { await SongDatabase.instance.updateSong(song); }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save song: $e')));
    } finally { if (mounted) setState(() => _saving = false); }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.song != null;
    InputDecoration decoration(String s) => InputDecoration(labelText: s, border: const OutlineInputBorder());
    String? requiredField(String? s) => (s == null || s.trim().isEmpty) ? 'This field is required' : null;
    return Scaffold(appBar: AppBar(title: Text(editing ? 'Edit Song' : 'Add Song')),
      body: Form(key: _form, child: ListView(padding: const EdgeInsets.all(16), children: [
        TextFormField(controller: _title, decoration: decoration('Title'), validator: requiredField),
        const SizedBox(height: 12),
        TextFormField(controller: _artist, decoration: decoration('Artist'), validator: requiredField),
        const SizedBox(height: 12),
        TextFormField(controller: _year, keyboardType: TextInputType.number, decoration: decoration('Year'),
          validator: (s) => requiredField(s) ?? (int.tryParse(s!.trim()) == null ? 'Enter a numeric year' : null)),
        const SizedBox(height: 12),
        TextFormField(controller: _genre, decoration: decoration('Genre'), validator: requiredField),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save), child: Text(editing ? 'Save Changes' : 'Save Song')),
      ])),
    );
  }
}
