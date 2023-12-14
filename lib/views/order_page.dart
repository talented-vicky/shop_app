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
  var _temp;

  Future _orderFuture() {
    return Provider.of<Order>(context, listen: false).getOrder();
  }

  @override
  void initState() {
    _temp = _orderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      // print("this should be printed once");
      Scaffold(
          appBar: AppBar(
            centerTitle: true,
            forceMaterialTransparency: true,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text("Orders", style: TextStyle(color: Colors.black)),
          ),
          drawer: const NavDrawer(),
          body: FutureBuilder(
              future: _temp,
              // use the above if there's other stuff that'll rebuild
              // other than body hence turned to stateful widget
              // future: Provider.of<Order>(context, listen: false).getOrder(),
              builder: (ctxt, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  // now I don't need to manage isLoading status as I did
                  // when usinig a stateful widget, connectionState does it
                  return const Center(child: CircularProgressIndicator());
                } else if (snapShot.error != null) {
                  return const Center(child: Text("An Error Occured"));
                }
                return Consumer<Order>(
                  builder: (ctxt, order, ch) => ListView.builder(
                      itemCount: order.allOrders.length,
                      itemBuilder: (BuildContext context, int ind) =>
                          OrderItem(order: order.allOrders[ind])),
                );
              }));
}
