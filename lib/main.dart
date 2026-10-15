import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(const MusicManagerApp());

class MusicManagerApp extends StatelessWidget {
  const MusicManagerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Music Library Manager', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
    home: const SessionGate(),
  );
}

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});
  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  late final Future<bool> _session;
  @override
  void initState() {
    super.initState();
    _session = SharedPreferences.getInstance().then((p) => p.getBool('isLogin') ?? false);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: _session,
    builder: (context, snapshot) {
      if (snapshot.hasError) return const Scaffold(body: Center(child: Text('Cannot read login session')));
      if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
      return snapshot.data! ? const HomeScreen() : const LoginScreen();
    },
  );
}
