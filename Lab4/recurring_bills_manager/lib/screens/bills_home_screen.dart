import 'package:flutter/material.dart';
import '../data/bill_database.dart';
import '../models/bill.dart';
import '../widgets/bill_card.dart';
import '../widgets/bills_banner.dart';
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
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    try {
      final db = BillDatabase.instance;
      final bills = await db.allBills();
      final unpaid = await db.unpaidBills();
      if (mounted) {
        setState(() {
          _bills = bills;
          _unpaid = unpaid;
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Cannot load bills: $e')));
    }
  }

  Future<void> _openForm({Bill? bill}) async {
    await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => BillFormScreen(bill: bill)));
    if (mounted) await _reload();
  }

  Widget _empty(String title, String subtitle) => Center(
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.receipt_long_outlined,
                    size: 56, color: Color(0xff888888)),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xff888888))),
                const SizedBox(height: 3),
                Text(subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xff888888))),
              ],
            )),
      );

  Widget _home() => Column(children: [
        const BillsBanner(),
        Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _bills.isEmpty
                    ? _empty('No bills yet',
                        'Press "+" button to add your recurring bills')
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 80),
                        itemCount: _bills.length,
                        itemBuilder: (context, i) => BillCard(
                            bill: _bills[i],
                            onTap: () => _openForm(bill: _bills[i])))),
      ]);

  Widget _summary() {
    final total = _unpaid.fold<double>(0, (sum, bill) => sum + bill.amount);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffffb33b)),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
                color: Color(0x18000000), blurRadius: 3, offset: Offset(0, 2))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Row(children: [
          Icon(Icons.receipt, color: Color(0xff993de0), size: 19),
          SizedBox(width: 8),
          Text('Outstanding Summary',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
        const Divider(height: 24, color: Color(0xffeeeeee)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Number of unpaid bills:',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          Text('${_unpaid.length}', style: const TextStyle(fontSize: 13)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          const Expanded(
              child: Text('Total outstanding:',
                  style: TextStyle(fontSize: 12, color: Colors.grey))),
          Flexible(
              child: Text(moneyVnd(total, currency: 'đ'),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffff9800)))),
        ]),
      ]),
    );
  }

  Widget _unpaidTab() => Column(children: [
        Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: Column(children: [
              Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                      color: Color(0xfffff3df), shape: BoxShape.circle),
                  child: const Icon(Icons.error,
                      color: Color(0xffff9800), size: 30)),
              const SizedBox(height: 12),
              const Text('Unpaid Bills',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Text(
                  '${_unpaid.length} ${_unpaid.length == 1 ? 'bill' : 'bills'} unpaid',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ])),
        Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(padding: const EdgeInsets.only(top: 10), children: [
                    if (_unpaid.isEmpty)
                      const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                              child: Text('No unpaid bills',
                                  style: TextStyle(color: Colors.grey)))),
                    for (final bill in _unpaid)
                      BillCard(
                          bill: bill,
                          compact: true,
                          onTap: () => _openForm(bill: bill)),
                    _summary(),
                  ])),
      ]);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: _tab == 0 ? _home() : _unpaidTab()),
        floatingActionButton: _tab == 0
            ? FloatingActionButton(
                backgroundColor: const Color(0xff8000ff),
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                tooltip: 'Add bill',
                onPressed: () => _openForm(),
                child: const Icon(Icons.add))
            : null,
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xffe0e0e0)))),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            currentIndex: _tab,
            selectedItemColor: const Color(0xff8000ff),
            unselectedItemColor: const Color(0xff999999),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            onTap: (i) {
              setState(() => _tab = i);
              _reload();
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.error_outline),
                  activeIcon: Icon(Icons.error),
                  label: 'Unpaid'),
            ],
          ),
        ),
      );
}
