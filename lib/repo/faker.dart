import 'package:faker/faker.dart';
import 'package:test_vaksina/model/stock_item.dart';

class DataGenerator {
  static final _faker = Faker();

  static List<StockItem> generateStockItems(int count) {
    return List.generate(count, (index) {
      return StockItem(
        name: _faker.lorem.words(_faker.randomGenerator.integer(10, min: 10)).join(' '),
        producer: _faker.lorem.words(_faker.randomGenerator.integer(20, min: 20)).join(' '),
        quantity: _faker.randomGenerator.integer(100, min: 1),
      );
    });
  }
}
