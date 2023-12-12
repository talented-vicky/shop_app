import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Order;

import '../widgets/order_item.dart';
import '../widgets/nav_drawer.dart';

class OrderPage extends StatefulWidget {
  static const routeName = '/order';

  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() => _isLoading = true);
      await Provider.of<Order>(context, listen: false).getOrder();
    }).then((_) => setState(() => _isLoading = false));
    super.initState();
  }

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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: order.allOrders.length,
                itemBuilder: (BuildContext context, int ind) =>
                    OrderItem(order: order.allOrders[ind]),
              ));
  }
}
