import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final dynamic authToken;
  final dynamic userId;

  List<OrderItem> orders = [];
  // this can only be accessed in this classSSS

  Order({required this.authToken, required this.orders, required this.userId});

  List<OrderItem> get allOrders {
    return [...orders];
    // ensuring outside of this class we can't access
    // "orders" hence we're pulling whatever order
    // list currently exists
  }

  Future<void> getOrder() async {
    final url = Uri.parse(
        'https://shop-app-73a49-default-rtdb.firebaseio.com/order/$userId.json?auth=$authToken');
    try {
      final resp = await http.get(url);

      var object = json.decode(resp.body);
      final List<OrderItem> orderList = [];

      if (object == null) {
        return;
      }

      final mapObject = object as Map<String, dynamic>;
      mapObject.forEach(
        (orderId, orderData) =>
            // add what I'm getting from this into the current
            // list of order
            orderList.add(OrderItem(
          id: orderId,
          totalAmount: orderData['totalAmount'],
          date: DateTime.parse(orderData['date']),
          cartproducts: (orderData['cartProducts'] as List<dynamic>)
              .map((cartData) => CartItem(
                    id: cartData['id'],
                    title: cartData['title'],
                    price: cartData['price'],
                    quantity: cartData['quantity'],
                  ))
              .toList(),
        )),
      );
      // replace the init list with this newly populated
      // order list
      // orders = orderList.reversed.toList();
      orders = orderList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> placeOrder(List<CartItem> cartitem, double orderPrice) async {
    final url = Uri.parse(
        "https://shop-app-73a49-default-rtdb.firebaseio.com/order/$userId.json?auth=$authToken");

    try {
      final datetime = DateTime.now();

      final resp = await http.post(url,
          body: json.encode({
            "totalAmount": orderPrice,
            "date": datetime.toIso8601String(),
            "creatorId": userId,
            "cartProducts": cartitem
                .map((prod) => {
                      "id": prod.id,
                      "price": prod.price,
                      "title": prod.title,
                      "quantity": prod.quantity,
                    })
                .toList(),
          }));

      final orderId = json.decode(resp.body)['name'];

      orders.add(OrderItem(
        id: orderId,
        totalAmount: orderPrice,
        cartproducts: cartitem,
        date: datetime,
      ));

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
