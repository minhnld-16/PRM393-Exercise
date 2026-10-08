import 'data/sample_data.dart';
import 'models/student.dart';
import 'services/student_service.dart';

// Bài tập logic-only: in console, không dựng Widget.
void main() {
  final students = [...sampleStudents];
  addStudent(students, Student(id: 4, name: 'Dung', age: 22, gpa: 3.5, major: 'Design'));
  updateGpa(students, 1, 3.6);
  final topStudents = filterHighGpa(students, 3.5);
  final display = prepareDisplayData(topStudents, (student) => '${student.name} - GPA: ${student.gpa}');
  for (final line in display) {
    print(line);
  }
}
