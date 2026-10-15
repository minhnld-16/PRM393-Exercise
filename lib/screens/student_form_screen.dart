import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? initialStudent;
  const StudentFormScreen({super.key, this.initialStudent});
  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.initialStudent?.id ?? '');
    _nameController = TextEditingController(text: widget.initialStudent?.name ?? '');
    _ageController = TextEditingController(text: widget.initialStudent?.age.toString() ?? '');
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState?.validate() != true) return;
    final student = Student(
      id: _idController.text.trim(),
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
    );
    Navigator.pop(context, student);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.initialStudent == null ? 'Thêm sinh viên' : 'Sửa sinh viên')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Form(key: _formKey, child: Column(children: [
        TextFormField(
          controller: _idController,
          decoration: const InputDecoration(labelText: 'Mã sinh viên'),
          validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập mã sinh viên' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Họ tên'),
          validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập họ tên' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _ageController,
          decoration: const InputDecoration(labelText: 'Tuổi'),
          keyboardType: TextInputType.number,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return 'Vui lòng nhập tuổi';
            final age = int.tryParse(text);
            if (age == null || age <= 0) return 'Tuổi không hợp lệ';
            return null;
          },
        ),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(onPressed: _saveStudent, child: const Text('Lưu')),
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ]),
      ])),
    ),
  );
}
