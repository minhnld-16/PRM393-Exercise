import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  const StudentTile({super.key, required this.student, this.onTap, this.onEdit});
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(student.name),
    subtitle: Text('ID: ${student.id} | Tuổi: ${student.age}'),
    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
      const Icon(Icons.chevron_right),
    ]),
    onTap: onTap,
  );
}
