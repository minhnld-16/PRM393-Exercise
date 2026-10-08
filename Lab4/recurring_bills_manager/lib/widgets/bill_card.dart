import 'package:flutter/material.dart';
import '../models/bill.dart';

String moneyVnd(double amount) {
  // Format VND without fetching any currency service.
  final number = amount == amount.roundToDouble()
      ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
  final parts = number.split('.');
  final digits = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  if (parts.length > 1) buffer.write(',${parts[1]}');
  return '${buffer.toString()} VND';
}

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback? onTap;
  final bool compact;
  const BillCard({super.key, required this.bill, this.onTap, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final paid = bill.status == 'Paid';
    return Card(margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12), child: ListTile(
      leading: CircleAvatar(child: Icon(paid ? Icons.check_circle : Icons.receipt_long)),
      title: Text(bill.billName, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(compact ? '${bill.category}\n${moneyVnd(bill.amount)}' :
        '${bill.category} • Due: ${bill.dueDate}\n${moneyVnd(bill.amount)}'),
      isThreeLine: !compact,
      trailing: compact ? null : Chip(
        label: Text(bill.status), backgroundColor: paid ? Colors.green.shade100 : Colors.orange.shade100),
      onTap: onTap,
    ));
  }
}
