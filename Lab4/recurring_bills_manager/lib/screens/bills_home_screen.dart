import 'package:flutter/material.dart';
import '../data/bill_database.dart';
import '../models/bill.dart';
import '../widgets/bill_card.dart';
import 'bill_form_screen.dart';

class BillsHomeScreen extends StatefulWidget {
  const BillsHomeScreen({super.key});
  @override
  State<BillsHomeScreen> createState() => _BillsHomeScreenState();
}

class _BillsHomeScreenState extends State<BillsHomeScreen> {
  List<Bill> _bills = [];
  List<Bill> _unpaid = [];
  int _tab = 0;
  bool _loading = true;

  @override
  void initState() { super.initState(); _reload(); }

  Future<void> _reload() async {
    try {
      final db = BillDatabase.instance;
      final bills = await db.allBills();
      final unpaid = await db.unpaidBills();
      if (mounted) setState(() { _bills = bills; _unpaid = unpaid; _loading = false; });
    } catch (e) {
      if (mounted) { setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot load bills: $e'))); }
    }
  }

  Future<void> _openForm({Bill? bill}) async {
    final result = await Navigator.of(context).push<String>(MaterialPageRoute(
      builder: (_) => BillFormScreen(bill: bill),
    ));
    if (!mounted) return;
    await _reload();
    if (mounted && result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final outstanding = _unpaid.fold<double>(0, (sum, bill) => sum + bill.amount);
    return Scaffold(
      appBar: AppBar(title: Text(_tab == 0 ? 'Recurring Bills' : 'Unpaid Bills')),
      body: _loading ? const Center(child: CircularProgressIndicator()) :
        _tab == 0 ? Column(children: [
          Padding(padding: const EdgeInsets.all(12), child: ClipRRect(
            borderRadius: BorderRadius.circular(16), child: Image.asset('assets/images/banner.png',
              fit: BoxFit.cover, width: double.infinity, height: 105))),
          Expanded(child: _bills.isEmpty ? const Center(child: Text('No bills yet. Tap + to add a bill.')) :
            ListView.builder(itemCount: _bills.length, itemBuilder: (context, i) =>
              BillCard(bill: _bills[i], onTap: () => _openForm(bill: _bills[i])))),
        ]) : Column(children: [
          Expanded(child: _unpaid.isEmpty ? const Center(child: Text('No unpaid bills')) :
            ListView.builder(itemCount: _unpaid.length, itemBuilder: (context, i) =>
              BillCard(bill: _unpaid[i], compact: true))),
          Card(margin: const EdgeInsets.all(16), color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(padding: const EdgeInsets.all(20), child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('Outstanding summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8), Text('Number of unpaid bills: ${_unpaid.length}'),
                const SizedBox(height: 4), Text('Total outstanding: ${moneyVnd(outstanding)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ]))),
        ]),
      floatingActionButton: _tab == 0 ? FloatingActionButton(
        onPressed: () => _openForm(), child: const Icon(Icons.add)) : null,
      bottomNavigationBar: BottomNavigationBar(currentIndex: _tab, onTap: (i) {
        setState(() => _tab = i);
        _reload();
      }, items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'All Bills'),
        BottomNavigationBarItem(icon: Icon(Icons.pending_actions), label: 'Unpaid'),
      ]),
    );
  }
}
