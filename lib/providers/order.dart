import 'package:flutter/material.dart';

import '../providers/cart.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final List<CartItem> cartproducts;
  final double totalAmount;
  final DateTime date;

  OrderItem({
    required this.id,
    required this.totalAmount,
    required this.cartproducts,
    required this.date,
  });
}

class Order with ChangeNotifier {
  final List<OrderItem> _orders = [];
  // this can only be accessed in this class

  List<OrderItem> get allOrders {
    return [..._orders];
    // ensuring outside of this class we can't access
    // "_orders" hence we're pulling whatever order
    // list currently exists
  }

  void placeOrder(List<CartItem> cartitem, double orderPrice) {
    _orders.add(OrderItem(
      id: DateTime.now().toString(),
      totalAmount: orderPrice,
      cartproducts: cartitem,
      date: DateTime.now(),
    ));

    notifyListeners();
  }
}
