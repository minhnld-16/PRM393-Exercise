import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/gallery_database.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(const ArtGalleryApp());

class ArtGalleryApp extends StatelessWidget {
  const ArtGalleryApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Art Gallery Manager', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal,
      scaffoldBackgroundColor: const Color(0xfff3f7f7)),
    home: const GallerySessionGate(),
  );
}

class GallerySessionGate extends StatefulWidget {
  const GallerySessionGate({super.key});
  @override
  State<GallerySessionGate> createState() => _GallerySessionGateState();
}

class _GallerySessionGateState extends State<GallerySessionGate> {
  late final Future<int?> _userId;
  @override
  void initState() {
    super.initState();
    // Check that the saved session refers to a user in the local database.
    _userId = () async {
      final savedId = (await SharedPreferences.getInstance()).getInt('galleryUserId');
      if (savedId == null) return null;
      final user = await GalleryDatabase.instance.userById(savedId);
      return user?.id;
    }();
  }
  @override
  Widget build(BuildContext context) => FutureBuilder<int?>(
    future: _userId,
    builder: (context, snapshot) {
      if (snapshot.hasError) return const Scaffold(body: Center(child: Text('Cannot open local gallery')));
      if (snapshot.connectionState != ConnectionState.done) return const Scaffold(body: Center(child: CircularProgressIndicator()));
      final id = snapshot.data;
      return id == null ? const LoginScreen() : HomeScreen(userId: id);
    },
  );
}
