import 'package:flutter/material.dart';
import 'package:lab5/core/theme/app_theme.dart';
import 'package:lab5/data/models/shopping_item.dart';
import 'package:lab5/data/repositories/shopping_repository.dart';
import 'package:lab5/presentation/widgets/shopping_banner.dart';
import 'package:lab5/presentation/widgets/item_card.dart';

class ItemsTab extends StatefulWidget {
  const ItemsTab({super.key, required this.revision, required this.onItemTap});
  final int revision;
  final ValueChanged<ShoppingItem> onItemTap;

  @override
  State<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  List<ShoppingItem> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ItemsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision) _load();
  }

  Future<void> _load() async {
    try {
      final items = await ShoppingRepository.instance.getAll();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load items from SQLite.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShoppingBanner(count: _items.length),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      TextButton(
                        onPressed: _load,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                )
              : _items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 48,
                        color: AppColors.muted,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Chưa có sản phẩm nào',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      Text(
                        'Nhấn nút "+" để thêm sản phẩm yêu thích',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 88),
                    itemCount: _items.length,
                    itemBuilder: (context, index) => ItemCard(
                      item: _items[index],
                      onTap: () => widget.onItemTap(_items[index]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
