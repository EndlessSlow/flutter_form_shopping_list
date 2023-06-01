import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_shopping_list/data/categories.dart';
import 'package:flutter_form_shopping_list/models/grocery_item.dart';
import 'package:flutter_form_shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error = '';

  void _loadItems() async {
    final url = Uri.https(
        'flutter-v3-backend-app-230529-default-rtdb.firebaseio.com',
        'shopping_list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to load items. Please try again later.';
        });
        return;
      }

      // print(response.body); // 'null'
      // nullをdecodeするとエラーになるので、nullチェックを行います。
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);

      final List<GroceryItem> loadedItems = [];

      // for (final item in listData.values) {
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.name == item.value['category'])
            .value;

        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      print(response.body);

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
      });
    }
  }

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

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

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
        'flutter-v3-backend-app-230529-default-rtdb.firebaseio.com',
        'shopping_list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // show errore message
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items added yet.'),
    );

    if (_isLoading) {
      content = const Center(
        // CircularProgressIndicator is a widget that shows a loading indicator.
        // CircularProgressIndicatorは、ローディングインジケータを表示するウィジェットです。
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        // ListTile widget is a convenient widget that provides many UI elements.
        // ListTileとは、多くのUI要素を提供する便利なウィジェットです。
        itemCount: _groceryItems.length,
        itemBuilder: ((context, index) => Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) {
                _removeItem(_groceryItems[index]);
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

    // エラーを表示します。
    if (_error != '') {
      content = Center(
        child: Text(_error!),
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
