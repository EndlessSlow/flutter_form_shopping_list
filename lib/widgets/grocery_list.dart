import 'package:flutter/material.dart';
import 'package:flutter_form_shopping_list/models/grocery_item.dart';
import 'package:flutter_form_shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    // StatefulWidgetを使うと、contextをグローバルに使うことができなくなります。
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(String item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items added yet.'),
    );

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        // ListTile widget is a convenient widget that provides many UI elements.
        // ListTileとは、多くのUI要素を提供する便利なウィジェットです。
        itemCount: _groceryItems.length,
        itemBuilder: ((context, index) => Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) {
                _removeItem(_groceryItems[index].id);
              },
              child: ListTile(
                title: Text(_groceryItems[index].name),
                subtitle: Text(_groceryItems[index].category.name),
                trailing: Text(_groceryItems[index].quantity.toString()),
                leading: Container(
                  width: 50,
                  height: 50,
                  color: _groceryItems[index].category.color,
                ),
              ),
            )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
