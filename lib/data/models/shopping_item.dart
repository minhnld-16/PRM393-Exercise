/// Allowed SQLite status values in the Lab 5 specification.
enum ShoppingStatus {
  wishlist('Wishlist'),
  purchased('Purchased');

  const ShoppingStatus(this.value);
  final String value;

  static ShoppingStatus fromString(String raw) {
    return raw == ShoppingStatus.purchased.value
        ? ShoppingStatus.purchased
        : ShoppingStatus.wishlist;
  }

  ShoppingStatus get toggled => this == ShoppingStatus.wishlist
      ? ShoppingStatus.purchased
      : ShoppingStatus.wishlist;
}

class ShoppingItem {
  const ShoppingItem({
    this.id,
    required this.itemName,
    required this.category,
    required this.price,
    this.status = ShoppingStatus.wishlist,
  });

  final int? id;
  final String itemName;
  final String category;
  final double price;
  final ShoppingStatus status;

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'itemName': itemName,
    'category': category,
    'price': price,
    'status': status.value,
  };

  factory ShoppingItem.fromMap(Map<String, Object?> map) => ShoppingItem(
    id: map['id'] as int,
    itemName: map['itemName'] as String,
    category: map['category'] as String,
    price: (map['price'] as num).toDouble(),
    status: ShoppingStatus.fromString(map['status'] as String),
  );

  ShoppingItem copyWith({ShoppingStatus? status}) => ShoppingItem(
    id: id,
    itemName: itemName,
    category: category,
    price: price,
    status: status ?? this.status,
  );
}
