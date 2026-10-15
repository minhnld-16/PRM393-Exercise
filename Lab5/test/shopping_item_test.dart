import 'package:flutter_test/flutter_test.dart';
import 'package:lab5/core/utils/price_parser.dart';
import 'package:lab5/data/models/shopping_item.dart';

void main() {
  group('ShoppingItem', () {
    test('new item defaults to Wishlist and has no ID', () {
      const item = ShoppingItem(
        itemName: 'Nike Air Force 1',
        category: 'Fashion',
        price: 2500000,
      );
      expect(item.id, isNull);
      expect(item.status, ShoppingStatus.wishlist);
      expect(item.toMap().containsKey('id'), isFalse);
    });

    test('SQLite map round-trip preserves fields and REAL price', () {
      final item = ShoppingItem.fromMap({
        'id': 5,
        'itemName': 'Headphones',
        'category': 'Electronics',
        'price': 4200000,
        'status': 'Purchased',
      });
      expect(item.id, 5);
      expect(item.price, 4200000.0);
      expect(item.status, ShoppingStatus.purchased);
      expect(item.toMap()['status'], 'Purchased');
    });

    test('status toggles in both directions', () {
      expect(ShoppingStatus.wishlist.toggled, ShoppingStatus.purchased);
      expect(ShoppingStatus.purchased.toggled, ShoppingStatus.wishlist);
    });

    test('copyWith changes status without mutating source', () {
      const before = ShoppingItem(
        itemName: 'Lamp',
        category: 'Home',
        price: 300000,
      );
      final after = before.copyWith(status: ShoppingStatus.purchased);
      expect(before.status, ShoppingStatus.wishlist);
      expect(after.status, ShoppingStatus.purchased);
    });
  });

  group('PriceParser', () {
    test('accepts VND prices', () {
      expect(PriceParser.parse('4200000'), 4200000);
      expect(PriceParser.parse('4.200.000'), 4200000);
      expect(PriceParser.parse('4,200,000'), 4200000);
      expect(PriceParser.parse('125000.50'), 125000.5);
    });

    test('rejects empty, zero, negative and invalid input', () {
      expect(PriceParser.parse(''), isNull);
      expect(PriceParser.parse('0'), isNull);
      expect(PriceParser.parse('-42'), isNull);
      expect(PriceParser.parse('abc'), isNull);
      expect(PriceParser.parse('12.0.3'), isNull);
    });
  });
}
