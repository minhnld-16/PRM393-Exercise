import 'package:flutter_test/flutter_test.dart';
import 'package:recurring_bills_manager/models/bill.dart';
import 'package:recurring_bills_manager/widgets/bill_card.dart';

void main() {
  test('Bill parses SQLite REAL and ISO date', () {
    final bill = Bill.fromMap({'id': 1, 'bill_name': 'Electricity',
      'category': 'Utilities', 'amount': 850000.0, 'status': 'Unpaid',
      'due_date': '2025-10-30'});
    expect(bill.status, 'Unpaid');
    expect(bill.amount, 850000);
    expect(bill.toMap()['due_date'], '2025-10-30');
  });
  test('VND formatter displays thousands separator', () {
    expect(moneyVnd(850000), '850.000 VND');
  });
}
