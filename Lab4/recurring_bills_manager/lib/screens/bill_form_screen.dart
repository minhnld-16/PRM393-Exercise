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
  late final TextEditingController _name, _amount, _date;
  late String _category, _status;
  bool _busy = false;
  static const _categories = [
    'Utilities',
    'Rent',
    'Subscription',
    'Insurance',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.bill?.billName ?? '');
    final amount = widget.bill?.amount;
    _amount = TextEditingController(
        text: amount == null
            ? ''
            : amount == amount.roundToDouble()
                ? amount.toStringAsFixed(0)
                : amount.toString());
    _date = TextEditingController(text: widget.bill?.dueDate ?? '');
    _category = widget.bill?.category ?? 'Utilities';
    _status = widget.bill?.status ?? 'Unpaid';
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _message(String title, String message) => showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'))
          ],
        ),
      );

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

  String? _validationError() {
    if (_name.text.trim().isEmpty) return 'Please enter bill name';
    if (_category.isEmpty) return 'Please select category';
    final amount = _parseVnd(_amount.text);
    if (amount == null || !amount.isFinite || amount <= 0) {
      return 'Please enter a valid positive amount';
    }
    final date = _date.text.trim();
    if (date.isEmpty) return 'Please enter due date';
    final parsed = DateTime.tryParse(date);
    // DateTime.parse normalizes impossible dates, so compare each component.
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
        parsed == null ||
        parsed.year < 1900 ||
        parsed.year > 2100 ||
        parsed.toIso8601String().substring(0, 10) != date) {
      return 'Please enter a valid due date (YYYY-MM-DD)';
    }
    return null;
  }

  Future<void> _save() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    final error = _validationError();
    if (error != null) {
      await _message('Validation', error);
      return;
    }
    setState(() => _busy = true);
    final bill = Bill(
        id: widget.bill?.id,
        billName: _name.text.trim(),
        category: _category,
        amount: _parseVnd(_amount.text)!,
        status: _status,
        dueDate: _date.text.trim());
    try {
      if (widget.bill == null) {
        await BillDatabase.instance.add(bill);
      } else {
        await BillDatabase.instance.update(bill);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        await _message('Error', 'Cannot save bill: $e');
      }
      return;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    await _message(
        'Success',
        widget.bill == null
            ? 'Bill added successfully'
            : 'Bill updated successfully');
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (_busy) return;
    final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Confirm Delete'),
                content:
                    const Text('Are you sure you want to delete this bill?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('CANCEL')),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('DELETE')),
                ]));
    if (confirm != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await BillDatabase.instance.delete(widget.bill!.id!);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        await _message('Error', 'Cannot delete bill: $e');
      }
      return;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    await _message('Success', 'Bill deleted');
    if (mounted) Navigator.pop(context);
  }

  Widget _field(String label, Widget field) => Padding(
        padding: const EdgeInsets.only(bottom: 26),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 9),
          field,
        ]),
      );

  Widget _button(
          String label, IconData icon, Color color, VoidCallback onPressed) =>
      Expanded(
        child: FilledButton.icon(
          onPressed: _busy ? null : onPressed,
          style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          icon: Icon(icon, size: 16),
          label: Text(label, style: const TextStyle(fontSize: 13)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final editing = widget.bill != null;
    final categories = {..._categories, _category};
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: AutofillGroup(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    _field(
                        'Bill Name *',
                        TextField(
                            controller: _name,
                            enabled: !_busy,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                hintText: 'e.g. Electricity - September'))),
                    _field(
                        'Category *',
                        DropdownButtonFormField<String>(
                            initialValue: _category,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: categories
                                .map((v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v,
                                        style: const TextStyle(fontSize: 13))))
                                .toList(),
                            onChanged: _busy
                                ? null
                                : (v) => setState(
                                    () => _category = v ?? 'Utilities'))),
                    _field(
                        'Amount (VND) *',
                        TextField(
                            controller: _amount,
                            enabled: !_busy,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                hintText: 'e.g. 850000'))),
                    _field(
                        'Due Date (YYYY-MM-DD) *',
                        TextField(
                            controller: _date,
                            enabled: !_busy,
                            keyboardType: TextInputType.datetime,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                hintText: 'e.g. 2025-10-30'))),
                    _field(
                        'Status *',
                        DropdownButtonFormField<String>(
                            initialValue: _status,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Unpaid',
                                  child: Text('Unpaid',
                                      style: TextStyle(fontSize: 13))),
                              DropdownMenuItem(
                                  value: 'Paid',
                                  child: Text('Paid',
                                      style: TextStyle(fontSize: 13)))
                            ],
                            onChanged: _busy
                                ? null
                                : (v) =>
                                    setState(() => _status = v ?? 'Unpaid'))),
                    const SizedBox(height: 10),
                    Row(children: [
                      _button(
                          editing ? 'Update' : 'Save',
                          editing ? Icons.save_outlined : Icons.check_circle,
                          const Color(0xff4caf50),
                          _save),
                      if (editing) ...[
                        const SizedBox(width: 8),
                        _button('Delete', Icons.delete_outline,
                            const Color(0xffc40025), _delete),
                      ],
                      const SizedBox(width: 8),
                      _button(
                          'Back',
                          editing ? Icons.arrow_back : Icons.cancel,
                          const Color(0xff797979),
                          () => Navigator.pop(context)),
                    ]),
                    if (_busy)
                      const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: LinearProgressIndicator()),
                  ])),
            ),
          ),
        )),
      ),
    );
  }
}
