import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_vaksina/repo/faker.dart';
import 'package:test_vaksina/model/stock_item.dart';

class StockState {
  final List<StockItem> items;
  final bool isLoading;

  StockState({required this.items, this.isLoading = false});
}

class StockNotifier extends StateNotifier<StockState> {
  StockNotifier() : super(StockState(items: DataGenerator.generateStockItems(50)));

  void loadMore(int count) async {
    state = StockState(items: state.items, isLoading: true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    state = StockState(
      items: [...state.items, ...DataGenerator.generateStockItems(count)],
      isLoading: false,
    );
  }
}

final stockProvider = StateNotifierProvider<StockNotifier, StockState>((ref) {
  return StockNotifier();
});
