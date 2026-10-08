import 'package:flutter/material.dart';
import '../data/gallery_database.dart';
import '../models/artwork.dart';

class ArtworkFormScreen extends StatefulWidget {
  final int userId;
  final Artwork? artwork;
  const ArtworkFormScreen({super.key, required this.userId, this.artwork});
  @override
  State<ArtworkFormScreen> createState() => _ArtworkFormScreenState();
}

class _ArtworkFormScreenState extends State<ArtworkFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title, _artist, _year, _description;
  late String _category;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final a = widget.artwork;
    _title = TextEditingController(text: a?.title ?? '');
    _artist = TextEditingController(text: a?.artist ?? '');
    _year = TextEditingController(text: a?.year ?? '');
    _description = TextEditingController(text: a?.description ?? '');
    _category = a?.category ?? artworkCategories.first;
  }
  @override
  void dispose() {
    for (final c in [_title, _artist, _year, _description]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final a = Artwork(id: widget.artwork?.id, title: _title.text.trim(),
      artist: _artist.text.trim(), year: _year.text.trim(),
      category: _category, description: _description.text.trim(),
      createdBy: widget.artwork?.createdBy ?? widget.userId);
    try {
      if (widget.artwork == null) { await GalleryDatabase.instance.addArtwork(a); }
      else { await GalleryDatabase.instance.updateArtwork(a); }
      if (mounted) Navigator.pop(context,
        widget.artwork == null ? 'Artwork added successfully' : 'Artwork updated successfully');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot save artwork: $e')));
    } finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.artwork != null;
    String? requiredText(String? s) => s == null || s.trim().isEmpty ? 'This field is required' : null;
    InputDecoration decoration(String label) => InputDecoration(labelText: label, border: const OutlineInputBorder());
    return Scaffold(appBar: AppBar(title: Text(isEdit ? 'Edit Artwork' : 'Add Artwork')),
      body: Form(key: _form, child: ListView(padding: const EdgeInsets.all(16), children: [
        Text(isEdit ? 'Update Artwork' : 'New Artwork', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 14),
        TextFormField(controller: _title, decoration: decoration('Title'), validator: requiredText),
        const SizedBox(height: 12),
        TextFormField(controller: _artist, decoration: decoration('Artist'), validator: requiredText),
        const SizedBox(height: 12),
        TextFormField(controller: _year, keyboardType: TextInputType.number, decoration: decoration('Year'),
          validator: (s) => requiredText(s) ?? (int.tryParse(s!.trim()) == null ? 'Year must be numeric' : null)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: _category,
          decoration: decoration('Category'), items: artworkCategories.map((c) =>
            DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _category = v ?? artworkCategories.first)),
        const SizedBox(height: 12),
        TextFormField(controller: _description, maxLines: 4,
          decoration: decoration('Description'), validator: requiredText),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: _busy ? null : _save, icon: const Icon(Icons.save),
          label: Text(isEdit ? 'Save Changes' : 'Save Artwork')),
      ])),
    );
  }
}
