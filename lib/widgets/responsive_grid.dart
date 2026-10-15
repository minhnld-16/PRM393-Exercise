import 'package:flutter/material.dart';

class ResponsiveProductGrid extends StatelessWidget {
  const ResponsiveProductGrid({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      final int columns = maxWidth < 600 ? 2 : (maxWidth < 900 ? 3 : 4);
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Products (width: ${maxWidth.toStringAsFixed(0)} → $columns columns)',
          style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) => _ProductItemCard(
            title: 'Product number $index with a quite long name',
            price: '\$${(index + 1) * 10}',
          ),
        ),
      ]);
    },
  );
}

class _ProductItemCard extends StatelessWidget {
  final String title;
  final String price;
  const _ProductItemCard({required this.title, required this.price});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double titleFont = (width * 0.03).clamp(12, 16).toDouble();
    final double priceFont = (width * 0.035).clamp(14, 18).toDouble();
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: titleFont), maxLines: 2, overflow: TextOverflow.ellipsis),
        const Spacer(),
        Text(price, style: TextStyle(fontSize: priceFont, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}
