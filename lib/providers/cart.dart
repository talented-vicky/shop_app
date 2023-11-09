import 'package:flutter/material.dart';

// basically, you should use a getter when you wanna
// return/get a value/object/list, and a function when
// you wanna perform an actual action and requires listening

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

  Map<String, CartItem> get allItems {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
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
              quantity: itemExist.quantity + 1));
    } else {
      // hence, push object into map
      _items.putIfAbsent(prodId,
          () => CartItem(id: prodId, title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void undoItem(String prodId) {
    if (!_items.containsKey(prodId)) {
      // i.e qty is 0, hence item doesn't exist
      // code exits here
      return;
    }
    if (_items[prodId]!.quantity > 1) {
      // simply reduce (update) the product quantity rather
      // than remove entire product
      _items.update(
          prodId,
          (cartitem) => CartItem(
              id: cartitem.id,
              title: cartitem.title,
              price: cartitem.price,
              quantity: cartitem.quantity - 1));
    } else {
      // i.e qty is 1, hence remove entire product
      _items.remove(prodId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
