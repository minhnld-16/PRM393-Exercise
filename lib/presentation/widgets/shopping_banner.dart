import 'package:flutter/material.dart';

class ShoppingBanner extends StatelessWidget {
  const ShoppingBanner({super.key, required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color(0xFFFFE5CF)),
          const Positioned(left: 16, top: -12, child: TransformBag()),
          const Positioned(
            left: -18,
            top: 28,
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 140,
              color: Color(0xCCFFFFFF),
            ),
          ),
          const Positioned(
            right: 16,
            top: 6,
            child: Text(
              'SHOPPING\nWISHLIST\nAPP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8BCBB8),
                fontSize: 32,
                height: 1.02,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Colors.black.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Favorite Shopping Items',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (count > 0)
                    Text(
                      '$count items',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransformBag extends StatelessWidget {
  const TransformBag({super.key});
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: -0.1,
    child: const Icon(Icons.shopping_bag, size: 100, color: Color(0xFFA9DDCD)),
  );
}
