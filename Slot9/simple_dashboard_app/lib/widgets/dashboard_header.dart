import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Flexible tránh tràn khi màn hình hẹp.
        const Flexible(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, User 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: 4),
            Text('Welcome back to your dashboard', style: TextStyle(color: Colors.grey),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        )),
        const SizedBox(width: 12),
        Stack(
          clipBehavior: Clip.none,
          children: const [
            Icon(Icons.notifications, size: 28),
            Positioned(right: -2, top: -2, child: CircleAvatar(radius: 6, backgroundColor: Colors.red)),
          ],
        ),
      ],
    ),
  );
}
