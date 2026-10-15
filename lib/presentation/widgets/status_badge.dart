import 'package:flutter/material.dart';
import 'package:lab5/core/theme/app_theme.dart';
import 'package:lab5/data/models/shopping_item.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final ShoppingStatus status;

  @override
  Widget build(BuildContext context) {
    final purchased = status == ShoppingStatus.purchased;
    final color = purchased ? AppColors.green : AppColors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status.value,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
