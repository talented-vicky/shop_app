import 'package:flutter/material.dart';

class CartItem {
  final String id, title;
  final double price;
  final int quantity;
  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final objdem = {
    6789: {
      "prodId": "789dkdk",
      "title": "789dkdk",
      "price": 5600,
      "quantity": 1
    },
    98644: {
      "prodId": "9uf456",
      "title": "anotherKey",
      "price": 2450,
      "quantity": 3,
    }
  };

  Map<String, CartItem> get allItems {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String prodId, String title, double price) {
    // check if item already exists, then increase qty
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (itemExist) => CartItem(
                id: itemExist.id,
                title: itemExist.title,
                price: itemExist.price,
                quantity: itemExist.quantity + 1,
              ));
    } else {
      // hence, push object into map
      _items.putIfAbsent(
          prodId,
          () => CartItem(
                id: prodId,
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }
}
