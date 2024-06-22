import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_vaksina/model/stock_item.dart';
import 'package:test_vaksina/provider/stock_provider.dart';
import 'package:test_vaksina/widget/item_detail_dialog.dart';

class StockListScreen extends ConsumerStatefulWidget {
  const StockListScreen({super.key});

  @override
  StockListScreenState createState() => StockListScreenState();
}

class StockListScreenState extends ConsumerState<StockListScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // _focusNode.requestFocus();
  }

  void _onScroll() {
    final state = ref.read(stockProvider);
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !state.isLoading) {
      ref.read(stockProvider.notifier).loadMore(50);
    }
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _currentIndex = (_currentIndex + 1)
              .clamp(0, ref.read(stockProvider).items.length - 1);
          _scrollToIndex();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _currentIndex = (_currentIndex - 1)
              .clamp(0, ref.read(stockProvider).items.length - 1);
          _scrollToIndex();
        });
      }
    }
  }

  void _scrollToIndex() {
    const itemHeight = 72.0;
    _scrollController.animateTo(
      _currentIndex * itemHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showItemDetails(StockItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItemDetailDialog(item: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Items'),
      ),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: false,
        onKey: _onKey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.business, size: 16),
                            const SizedBox(width: 4),
                            Text(item.producer),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.confirmation_number, size: 16),
                            const SizedBox(width: 4),
                            Text('Qty: ${item.quantity}'),
                          ],
                        ),
                      ],
                    ),
                    focusColor: Colors.blue.withOpacity(0.2),
                    tileColor:
                        index % 2 == 0 ? Colors.black.withOpacity(0.03) : null,
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                        _showItemDetails(item);
                      });
                    },
                  );
                },
              ),
            ),
            if (state.isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
