import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool loggedOut;
  const LoginScreen({super.key, this.loggedOut = false});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.loggedOut) WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')));
    });
  }

  @override
  void dispose() { _username.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    // Exact hard-coded credentials from Lab 2, no database and no encryption.
    if (_username.text.trim() != 'admin' || _password.text != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')));
      return;
    }
    setState(() => _busy = true);
    try {
      (await SharedPreferences.getInstance()).setBool('isLogin', true);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute<void>(builder: (_) => const HomeScreen()), (_) => false);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot save session: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Music Library Manager')),
    body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(padding: const EdgeInsets.all(24), child: Form(key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.library_music, size: 72, color: Colors.deepPurple),
          const SizedBox(height: 16),
          TextFormField(controller: _username, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
            validator: (s) => (s == null || s.trim().isEmpty) ? 'Enter username' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            validator: (s) => (s == null || s.isEmpty) ? 'Enter password' : null),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: _busy ? null : _login, child: const Text('Login'))),
        ])),
      ),
    )),
  );
}
