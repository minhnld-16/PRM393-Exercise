import 'package:flutter/material.dart';
import '../data/gallery_database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_username, _email, _password, _confirm]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final db = GalleryDatabase.instance;
    try {
      final username = _username.text.trim();
      if (await db.usernameExists(username)) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username already exists')));
        return;
      }
      await db.register(username, _email.text.trim(), _password.text);
      if (mounted) Navigator.pop(context, 'Registration successful. Please log in.');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    } finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  Widget build(BuildContext context) {
    String? requiredText(String? value) => value == null || value.trim().isEmpty ? 'Required field' : null;
    return Scaffold(appBar: AppBar(title: const Text('Create your account')),
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 450),
        child: Form(key: _form, child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(20), children: [
          TextFormField(controller: _username, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()), validator: requiredText),
          const SizedBox(height: 12),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()), validator: requiredText),
          const SizedBox(height: 12),
          TextFormField(controller: _password, obscureText: true,
            decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), validator: requiredText),
          const SizedBox(height: 12),
          TextFormField(controller: _confirm, obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
            validator: (value) => requiredText(value) ?? (value != _password.text ? 'Passwords do not match' : null)),
          const SizedBox(height: 20),
          FilledButton(onPressed: _busy ? null : _register, child: const Text('Register')),
        ])),
      )),
    );
  }
}
