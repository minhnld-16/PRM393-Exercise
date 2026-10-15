import 'package:flutter/material.dart';
import 'package:lab5/core/theme/app_theme.dart';
import 'package:lab5/presentation/home/home_shell.dart';

class FavoriteShoppingApp extends StatelessWidget {
  const FavoriteShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Shopping Items',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeShell(),
    );
  }
}
