import 'package:flutter/material.dart';
import 'screens/bills_home_screen.dart';

void main() => runApp(const RecurringBillsApp());

class RecurringBillsApp extends StatelessWidget {
  const RecurringBillsApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Recurring Bills Manager',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xfff7f7fb)),
    home: const BillsHomeScreen(),
  );
}
