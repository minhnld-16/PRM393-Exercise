import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/student_list_screen.dart';
import 'screens/student_detail_screen.dart';

void main() => runApp(const StudentManagerApp());

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Student Manager',
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.home,
    routes: {
      AppRoutes.home: (_) => const HomeScreen(),
      AppRoutes.studentList: (_) => const StudentListScreen(),
      AppRoutes.studentDetail: (_) => const StudentDetailScreen(),
    },
    // Bài học chỉ giới thiệu onGenerateRoute. Không parse query id ở bài gốc.
    onGenerateRoute: (settings) {
      debugPrint('onGenerateRoute được gọi với: ${settings.name}');
      return null;
    },
    theme: ThemeData(primarySwatch: Colors.blue),
  );
}
