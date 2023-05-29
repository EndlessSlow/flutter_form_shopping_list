import 'package:flutter_form_shopping_list/models/category.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  // // This is a factory constructor. It allows us to create a GroceryItem
  // // from a map of key-value pairs. This is useful when we are reading
  // // data from a database.
  // factory GroceryItem.fromMap(Map<String, dynamic> map) {
  //   return GroceryItem(
  //     id: map['id'],
  //     name: map['name'],
  //     quantity: map['quantity'],
  //     category: map['category'],
  //   );
  // }

  // // This is a method that converts a GroceryItem into a map of key-value
  // // pairs. This is useful when we want to write data to a database.
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'quantity': quantity,
  //     'category': category,
  //   };
  // }
}
