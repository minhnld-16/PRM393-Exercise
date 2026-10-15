import '../models/student.dart';

void addStudent(List<Student> list, Student student) => list.add(student);

void updateGpa(List<Student> list, int studentId, double newGpa) {
  for (final student in list) {
    if (student.id == studentId) {
      student.gpa = newGpa;
      break;
    }
  }
}

List<Student> filterHighGpa(List<Student> list, double minGpa) =>
    list.where((student) => student.gpa >= minGpa).toList();

// Callback quyết định cách chuyển đối tượng Student thành text.
List<String> prepareDisplayData(
  List<Student> list,
  String Function(Student) formatter,
) => list.map(formatter).toList();
