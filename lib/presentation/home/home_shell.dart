import 'package:flutter/material.dart';
import 'package:lab5/core/theme/app_theme.dart';
import 'package:lab5/data/models/shopping_item.dart';
import 'package:lab5/presentation/add/add_item_screen.dart';
import 'package:lab5/presentation/detail/item_detail_screen.dart';
import 'package:lab5/presentation/home/items_tab.dart';
import 'package:lab5/presentation/widgets/message_dialog.dart';
import 'package:lab5/presentation/wishlist/wishlist_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  int _revision = 0;

  Future<void> _addItem() async {
    final created = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const AddItemScreen()));
    if (!mounted) return;
    if (created != null) {
      setState(() {
        _tab = 0;
        _revision++;
      });
      await showMessageDialog(context, 'Success', created);
    }
  }

  Future<void> _openDetail(ShoppingItem item) async {
    final outcome = await Navigator.of(context).push<DetailOutcome>(
      MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
    );
    if (!mounted) return;
    // Always refresh: status may have changed even if Back/AppBar was used.
    setState(() => _revision++);
    if (outcome == DetailOutcome.deleted) {
      await showMessageDialog(context, 'Success', 'Item deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            ItemsTab(revision: _revision, onItemTap: _openDetail),
            WishlistTab(revision: _revision, onItemTap: _openDetail),
          ],
        ),
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: _addItem,
              tooltip: 'Add item',
              child: const Icon(Icons.add),
              backgroundColor: AppColors.purple,
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (index) => setState(() => _tab = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.purple,
        unselectedItemColor: AppColors.muted,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
        ],
      ),
    );
  }
}
