import 'package:flutter/material.dart';
import '../models/plan.dart';
import '../widgets/primary_button.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});
  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      helpText: 'Select plan date',
    );
    if (!mounted || picked == null) return; // Cancel trả null.
    setState(() => _selectedDate = DateTime(picked.year, picked.month, picked.day));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Select plan time',
    );
    if (!mounted || picked == null) return;
    setState(() => _selectedTime = picked);
  }

  String _dateLabel() {
    final d = _selectedDate;
    if (d == null) return 'Choose Date';
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
  String _timeLabel() {
    final t = _selectedTime;
    if (t == null) return 'Choose Time';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return _showError('Title is required');
    if (_selectedDate == null) return _showError('Please choose a date');
    if (_selectedTime == null) return _showError('Please choose a time');
    Navigator.pop(context, Plan(title: title, date: _selectedDate!, time: _selectedTime!));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create Plan')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Plan Title', hintText: 'e.g. Study Flutter'),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: _pickDate, child: Text(_dateLabel()))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton(onPressed: _pickTime, child: Text(_timeLabel()))),
            ],
          ),
          const Spacer(),
          PrimaryButton(text: 'Save', onPressed: _save),
        ],
      ),
    ),
  );
}
