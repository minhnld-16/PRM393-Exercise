import 'package:flutter/material.dart';
import '../models/bill.dart';

String moneyVnd(double amount, {String currency = 'VND'}) {
  final number = amount == amount.roundToDouble()
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
  final parts = number.split('.');
  final digits = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  if (parts.length > 1) buffer.write(',${parts[1]}');
  return '$buffer $currency';
}

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback? onTap;
  final bool compact;
  const BillCard(
      {super.key, required this.bill, this.onTap, this.compact = false});

  IconData get _icon {
    switch (bill.category.toLowerCase()) {
      case 'rent':
        return Icons.home_outlined;
      case 'subscription':
        return Icons.wifi;
      case 'utilities':
        return Icons.bolt;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xff993de0);
    const orange = Color(0xffff9800);
    final paid = bill.status == 'Paid';
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: compact ? 0 : 1.5,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(children: [
              Container(
                width: compact ? 22 : 36,
                height: compact ? 22 : 36,
                decoration: BoxDecoration(
                  color: compact ? orange : const Color(0xfff7f1fc),
                  shape: BoxShape.circle,
                ),
                child: Icon(compact ? Icons.priority_high : _icon,
                    color: compact ? Colors.white : purple,
                    size: compact ? 15 : 23),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(bill.billName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(bill.category,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey)),
                  ])),
              const SizedBox(width: 8),
              Flexible(
                  child: Text(moneyVnd(bill.amount, currency: 'đ'),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: compact ? orange : purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w700))),
            ]),
            if (!compact) ...[
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.calendar_month_outlined,
                    size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                    child: Text('Due: ${bill.dueDate}',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey))),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                      color: paid ? const Color(0xff4caf50) : orange,
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(bill.status,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ),
              ]),
            ],
          ]),
        ),
      ),
    );
  }
}
