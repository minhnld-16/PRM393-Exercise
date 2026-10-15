import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Student) {
      return const Scaffold(body: Center(child: Text('Dữ liệu sinh viên không hợp lệ')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sinh viên')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ID: ${args.id}', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Tên: ${args.name}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Tuổi: ${args.age}', style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Center(child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Quay lại danh sách'),
          )),
        ]),
      ),
    );
  }
}
