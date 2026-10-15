import 'package:flutter/material.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return; // Không thêm task rỗng.
    setState(() {
      _tasks.add(Task(title: text));
      _controller.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTaskItem(Task task, int index) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) {
            if (value == null) return;
            setState(() => task.isDone = value);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : Colors.black,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => setState(() => _tasks.removeAt(index)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((task) => task.isDone).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Student Task Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Hoàn thành: $completedCount / ${_tasks.length}'),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              onSubmitted: (_) => _addTask(),
              decoration: InputDecoration(
                labelText: 'Nhập tên công việc...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('Chưa có công việc nào!'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) =>
                          _buildTaskItem(_tasks[index], index),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
