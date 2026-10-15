import 'package:flutter/material.dart';

/// Code-drawn banner stays crisp at both phone and desktop widths.
class BillsBanner extends StatelessWidget {
  const BillsBanner({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 150,
        child: ClipRect(
            child: Stack(children: [
          Container(
              decoration: const BoxDecoration(
            color: Color(0xfffff4e3),
            border: Border(top: BorderSide(color: Color(0xffa34ee4), width: 2)),
          )),
          Positioned.fill(child: CustomPaint(painter: _PatternPainter())),
          Positioned(
              left: 24,
              top: 22,
              right: 112,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: const Text('RECURRING\nBILLS MANAGER',
                      style: TextStyle(
                          fontSize: 32,
                          height: 1.04,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff493c51))))),
          Positioned(
              right: 24,
              top: 3,
              width: 108,
              height: 164,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color(0xff8097bd),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: const Color(0xff514c63), width: 3)),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xfffcfcfc),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(children: [
                    Container(
                        width: 46,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                            color: Color(0xff514c63),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(6)))),
                    _phoneRow(
                        Icons.bolt, 'Electricity', const Color(0xffffc459)),
                    _phoneRow(Icons.water_drop_outlined, 'Water',
                        const Color(0xff8cced8)),
                    _phoneRow(
                        Icons.home_outlined, 'Rent', const Color(0xffe8a4ad)),
                    _phoneRow(Icons.wifi, 'Internet', const Color(0xffc6a2ec)),
                  ]),
                ),
              )),
          Positioned(
              left: 36,
              top: 111,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                  decoration: BoxDecoration(
                      color: const Color(0xffffd295),
                      border: Border.all(color: const Color(0xff6c5963)),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('ADD',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  height: 39,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  color: const Color(0x99000000),
                  child: const Text('Recurring Bills',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)))),
        ])),
      );

  Widget _phoneRow(IconData icon, String label, Color color) => Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 9),
        child: Row(children: [
          Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xff686272))),
              child: Icon(icon, size: 17, color: const Color(0xff514c63))),
          const SizedBox(width: 4),
          Expanded(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(label,
                      style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xff493c51),
                          fontWeight: FontWeight.w600)))),
        ]),
      );
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffefe4d7)
      ..strokeWidth = 1;
    for (double x = 10; x < size.width; x += 24) {
      for (double y = 12; y < size.height; y += 24) {
        canvas.drawLine(Offset(x - 3, y), Offset(x + 3, y), paint);
        canvas.drawLine(Offset(x, y - 3), Offset(x, y + 3), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
