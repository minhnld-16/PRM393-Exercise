import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/gallery_database.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool loggedOut;
  const LoginScreen({super.key, this.loggedOut = false});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.loggedOut) WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out successfully')));
    });
  }
  @override
  void dispose() { _username.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final user = await GalleryDatabase.instance.authenticate(_username.text.trim(), _password.text);
      if (!mounted) return;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid username or password')));
      } else {
        await (await SharedPreferences.getInstance()).setInt('galleryUserId', user.id!);
        if (mounted) Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute<void>(builder: (_) => HomeScreen(userId: user.id!)), (_) => false);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Art Gallery Manager')),
    body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 430), child:
      Form(key: _form, child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(24), children: [
        const Icon(Icons.museum, color: Colors.teal, size: 70),
        const SizedBox(height: 12),
        const Center(child: Text('Sign in to manage your collection')),
        const SizedBox(height: 24),
        TextFormField(controller: _username, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
          validator: (s) => s == null || s.trim().isEmpty ? 'Enter username' : null),
        const SizedBox(height: 12),
        TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
          validator: (s) => s == null || s.isEmpty ? 'Enter password' : null),
        const SizedBox(height: 20),
        FilledButton(onPressed: _busy ? null : _login, child: const Text('Login')),
        TextButton(onPressed: () async {
          final msg = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
          if (msg != null && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }, child: const Text('No account? Register now')),
      ])),
    )),
  );
}
