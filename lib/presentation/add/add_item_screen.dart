import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab5/core/theme/app_theme.dart';
import 'package:lab5/presentation/widgets/message_dialog.dart';
import 'package:lab5/core/utils/price_parser.dart';
import 'package:lab5/data/models/shopping_item.dart';
import 'package:lab5/data/repositories/shopping_repository.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  static const _categories = [
    'Fashion',
    'Electronics',
    'Home',
    'Books',
    'Beauty',
    'Sports',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = _categories.first;
  ShoppingStatus _status = ShoppingStatus.wishlist;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) {
      await showMessageDialog(
        context,
        'Error',
        _nameController.text.trim().isEmpty
            ? 'Please enter item name'
            : 'Enter a valid price greater than 0',
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final item = ShoppingItem(
        itemName: _nameController.text.trim(),
        category: _category,
        price: PriceParser.parse(_priceController.text)!,
        status: _status,
      );
      await ShoppingRepository.instance.add(item);
      if (!mounted) return;
      Navigator.of(
        context,
      ).pop('Added "${item.itemName}" to ${item.status.value.toLowerCase()}');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Add shopping item')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  const _FormLabel('Item Name *'),
                  TextFormField(
                    controller: _nameController,
                    maxLength: 100,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Nike Air Force 1',
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  const _FormLabel('Category *'),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(),
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: _saving
                        ? null
                        : (value) =>
                              setState(() => _category = value ?? _category),
                  ),
                  const SizedBox(height: 18),
                  const _FormLabel('Price (VND) *'),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d., ]')),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'e.g. 2500000',
                      suffixText: '₫',
                    ),
                    validator: (value) => PriceParser.parse(value ?? '') == null
                        ? 'Enter a valid price greater than 0'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  const _FormLabel('Status'),
                  DropdownButtonFormField<ShoppingStatus>(
                    initialValue: _status,
                    decoration: const InputDecoration(),
                    items: ShoppingStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.value),
                          ),
                        )
                        .toList(),
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _status = value ?? _status),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.green,
                          ),
                          onPressed: _saving ? null : _save,
                          icon: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline_rounded),
                          label: const Text('Save'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _saving
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('Cancel'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.muted,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.dark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
