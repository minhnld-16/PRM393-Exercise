import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterStarterApp());
}

class FlutterStarterApp extends StatelessWidget {
  const FlutterStarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StarterScreen(),
    );
  }
}

class StarterScreen extends StatelessWidget {
  const StarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Đề không có tên sinh viên: thay biến này bằng tên thật của bạn.
    final String studentName = 'Tên sinh viên';
    final String reason = 'Why I learn Flutter';
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Starter App')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(studentName, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            Text(reason, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
