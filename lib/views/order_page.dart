import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Order;

import '../widgets/order_item.dart';
import '../widgets/nav_drawer.dart';

class OrderPage extends StatelessWidget {
  static const routeName = '/order';

  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Orders", style: TextStyle(color: Colors.black)),
      ),
      drawer: const NavDrawer(),
      body: ListView.builder(
        itemCount: order.allOrders.length,
        itemBuilder: (BuildContext context, int ind) {
          return OrderItem(
            order: order.allOrders[ind],
          );
        },
      ),
    );
  }
}


// i3ec95fxxdyukdq