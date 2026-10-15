import 'package:flutter/material.dart';
import 'package:lab5/core/theme/app_theme.dart';
import 'package:lab5/core/utils/money_formatter.dart';
import 'package:lab5/data/models/shopping_item.dart';
import 'package:lab5/data/repositories/shopping_repository.dart';

/// Root screen uses this to show a success notice after navigation returns.
enum DetailOutcome { deleted }

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key, required this.item});
  final ShoppingItem item;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late ShoppingItem _item;
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Future<void> _toggleStatus() async {
    if (_working || _item.id == null) return;
    setState(() => _working = true);
    final next = _item.status.toggled;
    try {
      await ShoppingRepository.instance.setStatus(_item.id!, next);
      if (!mounted) return;
      setState(() => _item = _item.copyWith(status: next));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              next == ShoppingStatus.purchased
                  ? 'Marked as Purchased.'
                  : 'Moved back to Wishlist.',
            ),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update item status.')),
      );
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _deleteItem() async {
    if (_working || _item.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
          'Are you sure you want to delete "${_item.itemName}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _working = true);
    try {
      await ShoppingRepository.instance.delete(_item.id!);
      if (!mounted) return;
      Navigator.pop(context, DetailOutcome.deleted);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete the item.')),
      );
      setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_item.itemName)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 19,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8E4EF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _DetailRow(
                        icon: Icons.tag_rounded,
                        label: 'ID',
                        value: '#${_item.id ?? '-'}',
                      ),
                      _DetailRow(
                        icon: Icons.category_outlined,
                        label: 'Category',
                        value: _item.category,
                      ),
                      _DetailRow(
                        icon: Icons.payments_outlined,
                        label: 'Price',
                        value: MoneyFormatter.vnd(_item.price),
                        valueColor: AppColors.purple,
                      ),
                      _DetailRow(
                        icon: Icons.flag_outlined,
                        label: 'Status',
                        value: _item.status.value,
                        valueColor: _item.status == ShoppingStatus.purchased
                            ? AppColors.green
                            : AppColors.orange,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ActionTile(
                        color: AppColors.orange,
                        icon: _item.status == ShoppingStatus.wishlist
                            ? Icons.check_circle_outline_rounded
                            : Icons.favorite_border_rounded,
                        text: _item.status == ShoppingStatus.wishlist
                            ? 'Mark Purchased'
                            : 'Move to Wishlist',
                        onPressed: _working ? null : _toggleStatus,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _ActionTile(
                        color: AppColors.red,
                        icon: Icons.delete_outline_rounded,
                        text: 'Delete',
                        onPressed: _working ? null : _deleteItem,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _ActionTile(
                        color: const Color(0xFF808080),
                        icon: Icons.arrow_back_rounded,
                        text: 'Back',
                        onPressed: _working
                            ? null
                            : () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                if (_working) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.dark,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 19, color: AppColors.muted),
              const SizedBox(width: 11),
              SizedBox(
                width: 86,
                child: Text(
                  label,
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.color,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final Color color;
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 11),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26),
            const SizedBox(height: 7),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
