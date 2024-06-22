// item_detail_dialog.dart
import 'package:flutter/material.dart';
import 'package:test_vaksina/model/stock_item.dart';

class ItemDetailDialog extends StatelessWidget {
  final StockItem item;

  const ItemDetailDialog({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Item Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.label),
              title: Text('Name'),
              subtitle: Text(item.name),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Producer'),
              subtitle: Text(item.producer),
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Quantity'),
              subtitle: Text(item.quantity.toString()),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
