import 'package:flutter/material.dart';
import 'package:lab5/core/theme/app_theme.dart';
import 'package:lab5/core/utils/money_formatter.dart';
import 'package:lab5/data/models/shopping_item.dart';
import 'package:lab5/data/repositories/shopping_repository.dart';
import 'package:lab5/presentation/widgets/empty_state.dart';
import 'package:lab5/presentation/widgets/item_card.dart';

class WishlistTab extends StatefulWidget {
  const WishlistTab({
    super.key,
    required this.revision,
    required this.onItemTap,
  });

  final int revision;
  final ValueChanged<ShoppingItem> onItemTap;

  @override
  State<WishlistTab> createState() => _WishlistTabState();
}

class _WishlistTabState extends State<WishlistTab> {
  List<ShoppingItem> _items = [];
  bool _loading = true;
  String? _error;

  double get _total => _items.fold<double>(0, (sum, item) => sum + item.price);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant WishlistTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision) _load();
  }

  Future<void> _load() async {
    try {
      final items = await ShoppingRepository.instance.getWishlist();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load wishlist from SQLite.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.purple, width: 2),
              bottom: BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 27,
                backgroundColor: Color(0xFFFFF3E0),
                child: Icon(Icons.favorite, color: AppColors.orange, size: 30),
              ),
              const SizedBox(height: 12),
              const Text(
                'Wishlist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${_items.length} items in wishlist',
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: _loading || _error != null || _items.isEmpty
                  ? 1
                  : _items.length + 1,
              itemBuilder: (context, index) {
                if (_loading)
                  return const Center(child: CircularProgressIndicator());
                if (_error != null)
                  return Center(
                    child: Column(
                      children: [
                        Text(_error!),
                        TextButton(
                          onPressed: _load,
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  );
                if (_items.isEmpty)
                  return const EmptyState(
                    asset: 'assets/images/wishlist_heart.png',
                    title: 'Your wishlist is empty',
                    subtitle: 'Items marked Wishlist will appear here.',
                  );
                if (index == _items.length) return _summary();
                final item = _items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.white,
                    elevation: 1,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => widget.onItemTap(item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: AppColors.orange,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              categoryIcon(item.category),
                              color: AppColors.orange,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.category,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              MoneyFormatter.vnd(item.price),
                              style: const TextStyle(
                                color: AppColors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _summary() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.orange, width: 1.5),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 3,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        const Row(
          children: [
            Icon(Icons.calculate, size: 19, color: AppColors.purple),
            SizedBox(width: 8),
            Text(
              'Total Estimate',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        const Divider(height: 24),
        Row(
          children: [
            const Text(
              'Number of items:',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const Spacer(),
            Text('${_items.length}', style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Total cost:',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const Spacer(),
            Text(
              MoneyFormatter.vnd(_total),
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          color: AppColors.background,
          padding: const EdgeInsets.all(8),
          child: const Row(
            children: [
              Icon(Icons.info, color: AppColors.muted, size: 12),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'This is the estimated total for items you want to buy',
                  style: TextStyle(color: AppColors.muted, fontSize: 9),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
