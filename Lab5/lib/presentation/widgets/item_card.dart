import 'package:flutter/material.dart';
import 'package:lab5/core/theme/app_theme.dart';
import 'package:lab5/core/utils/money_formatter.dart';
import 'package:lab5/data/models/shopping_item.dart';
import 'package:lab5/presentation/widgets/status_badge.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Fashion':
      return Icons.checkroom_outlined;
    case 'Electronics':
      return Icons.devices_outlined;
    case 'Home':
      return Icons.chair_outlined;
    case 'Books':
      return Icons.menu_book_outlined;
    case 'Beauty':
      return Icons.spa_outlined;
    case 'Sports':
      return Icons.sports_basketball_outlined;
    default:
      return Icons.shopping_bag_outlined;
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.showStatus = true,
  });

  final ShoppingItem item;
  final VoidCallback onTap;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.purple.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        categoryIcon(item.category),
                        color: AppColors.purple,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.category,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        MoneyFormatter.vnd(item.price),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (showStatus) StatusBadge(status: item.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
