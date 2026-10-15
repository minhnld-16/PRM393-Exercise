import 'package:flutter/material.dart';
import 'package:lab5/app.dart';
import 'package:lab5/data/local/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.initialize();
  runApp(const FavoriteShoppingApp());
}
