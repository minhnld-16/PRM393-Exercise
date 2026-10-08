import '../models/item.dart';

class FakeApiService {
  static Future<List<Item>> fetchItems() async {
    print('1. BẮT ĐẦU gọi fetchItems');
    await Future.delayed(const Duration(seconds: 2));
    print('2. SAU khi Future.delayed xong');
    return [
      Item(name: 'Táo', price: 10000),
      Item(name: 'Cam', price: 15000),
      Item(name: 'Chuối', price: 8000),
    ];
  }
}
