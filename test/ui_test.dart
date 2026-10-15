import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recurring_bills_manager/models/bill.dart';
import 'package:recurring_bills_manager/screens/bill_form_screen.dart';
import 'package:recurring_bills_manager/widgets/bill_card.dart';
import 'package:recurring_bills_manager/widgets/bills_banner.dart';

const bill = Bill(
    id: 1,
    billName: 'Internet - Viettel',
    category: 'Subscription',
    amount: 250000,
    status: 'Paid',
    dueDate: '2025-11-01');

void main() {
  testWidgets('Empty name uses the reference Validation dialog',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: const BillFormScreen()));
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Validation'), findsOneWidget);
    expect(find.text('Please enter bill name'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Validation'), findsNothing);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('Impossible dates are rejected before saving', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: BillFormScreen()));
    final inputs = find.byType(TextField);
    await tester.enterText(inputs.at(0), 'Electricity');
    await tester.enterText(inputs.at(1), '850.000');
    await tester.enterText(inputs.at(2), '2026-02-30');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter a valid due date (YYYY-MM-DD)'),
        findsOneWidget);
  });

  testWidgets('Editing preserves values and cancelling delete keeps the form',
      (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: BillFormScreen(bill: bill)));
    expect(find.text('Internet - Viettel'), findsOneWidget);
    expect(find.text('250000'), findsOneWidget);
    expect(find.text('2025-11-01'), findsOneWidget);
    await tester.ensureVisible(find.text('Delete'));
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Delete'), findsOneWidget);
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Delete'), findsNothing);
    expect(find.text('Update'), findsOneWidget);
  });

  testWidgets('Phone layout fits the banner, card and edit buttons',
      (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
            body: Column(children: [
      BillsBanner(),
      BillCard(bill: bill),
      BillCard(bill: bill, compact: true),
    ]))));
    expect(find.text('250.000 đ'), findsNWidgets(2));
    expect(find.text('Paid'), findsOneWidget);
    expect(find.text('Due: 2025-11-01'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester
        .pumpWidget(const MaterialApp(home: BillFormScreen(bill: bill)));
    await tester.ensureVisible(find.text('Update'));
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
