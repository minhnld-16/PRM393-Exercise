import 'package:flutter/material.dart';
import '../data/bill_database.dart';
import '../models/bill.dart';

class BillFormScreen extends StatefulWidget {
  final Bill? bill;
  const BillFormScreen({super.key, this.bill});
  @override
  State<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends State<BillFormScreen> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _name, _category, _amount;
  DateTime? _date;
  late String _status;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.bill?.billName ?? '');
    _category = TextEditingController(text: widget.bill?.category ?? '');
    _amount = TextEditingController(text: widget.bill?.amount.toString() ?? '');
    _status = widget.bill?.status ?? 'Unpaid';
    _date = widget.bill == null ? null : DateTime.tryParse(widget.bill!.dueDate);
  }

  @override
  void dispose() { _name.dispose(); _category.dispose(); _amount.dispose(); super.dispose(); }

  String _iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final date = await showDatePicker(context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(1900), lastDate: DateTime(2100));
    if (date != null && mounted) setState(() => _date = date);
  }

  // Accept 850000 and Vietnamese grouping (850.000 = 850000 VND).
  double? _parseVnd(String raw) {
    var value = raw.trim().replaceAll(' ', '');
    if (RegExp(r'^\d{1,3}(\.\d{3})+$').hasMatch(value)) {
      value = value.replaceAll('.', '');
    } else if (RegExp(r'^\d{1,3}(,\d{3})+$').hasMatch(value)) {
      value = value.replaceAll(',', '');
    } else {
      value = value.replaceAll(',', '.');
    }
    return double.tryParse(value);
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a due date')));
      return;
    }
    setState(() => _busy = true);
    final amount = _parseVnd(_amount.text)!;
    final bill = Bill(id: widget.bill?.id, billName: _name.text.trim(),
      category: _category.text.trim(), amount: amount, status: _status, dueDate: _iso(_date!));
    try {
      if (widget.bill == null) { await BillDatabase.instance.add(bill); }
      else { await BillDatabase.instance.update(bill); }
      if (mounted) Navigator.pop(context, widget.bill == null ? 'Bill added successfully' : 'Bill updated successfully');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot save bill: $e')));
    } finally { if (mounted) setState(() => _busy = false); }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(context: context,
      builder: (context) => AlertDialog(title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this bill?'),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))]));
    if (confirm != true) return;
    setState(() => _busy = true);
    try {
      await BillDatabase.instance.delete(widget.bill!.id!);
      if (mounted) Navigator.pop(context, 'Bill deleted');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot delete bill: $e')));
    } finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.bill != null;
    String? requiredText(String? text) => text == null || text.trim().isEmpty ? 'This field is required' : null;
    InputDecoration dec(String label) => InputDecoration(labelText: label, border: const OutlineInputBorder());
    return Scaffold(appBar: AppBar(title: Text(editing ? 'Update Bill' : 'Add Bill')),
      body: Form(key: _key, child: ListView(padding: const EdgeInsets.all(16), children: [
        TextFormField(controller: _name, decoration: dec('Bill Name *'), validator: requiredText),
        const SizedBox(height: 12),
        TextFormField(controller: _category, decoration: dec('Category *'), validator: requiredText),
        const SizedBox(height: 12),
        TextFormField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: dec('Amount (VND) *'),
          validator: (s) {
            if (requiredText(s) != null) return 'Amount is required';
            final value = _parseVnd(s!);
            return value == null || !value.isFinite || value <= 0 ? 'Enter a valid positive amount' : null;
          }),
        const SizedBox(height: 12),
        OutlinedButton.icon(onPressed: _pickDate, icon: const Icon(Icons.calendar_month),
          label: Text(_date == null ? 'Choose Due Date *' : 'Due Date: ${_iso(_date!)}')),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: _status,
          decoration: dec('Status *'),
          items: const [DropdownMenuItem(value: 'Unpaid', child: Text('Unpaid')),
            DropdownMenuItem(value: 'Paid', child: Text('Paid'))],
          onChanged: (v) => setState(() => _status = v ?? 'Unpaid')),
        const SizedBox(height: 22),
        if (editing)
          Row(children: [
            Expanded(child: FilledButton(onPressed: _busy ? null : _save, child: const Text('Update'))),
            const SizedBox(width: 6),
            Expanded(child: FilledButton.tonal(onPressed: _busy ? null : _delete, child: const Text('Delete'))),
            const SizedBox(width: 6),
            Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))),
          ])
        else ...[
          FilledButton.icon(onPressed: _busy ? null : _save, icon: const Icon(Icons.save), child: const Text('Save')),
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Back')),
        ],
      ])),
    );
  }
}
