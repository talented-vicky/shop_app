import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../providers/cart.dart' show Cart;
// this is me excluding CartItem from the import

import '../widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // setting up a listener (that causes app rebuild)
    final cart = Provider.of<Cart>(context);
    // final order = Provider.of<Order>(context);

    return Container(
        child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text('Cart', style: TextStyle(color: Colors.black)),
            ),
            body: Column(children: [
              Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 30),
                            Chip(
                              label: Text('\$ ${cart.totalAmount}'),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  Provider.of<Order>(
                                    context,
                                    listen: false,
                                    // not listening coz I just wanna dispatch an action
                                  ).placeOrder(
                                    cart.allItems.values.toList(),
                                    cart.totalAmount,
                                  );
                                  // now clear Cart
                                  cart.clearCart;
                                },
                                child: Text(
                                  "Order Now!",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ))
                          ]))),
              Expanded(
                  child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (BuildContext context, int ind) {
                  return CartItem(
                    // id: cart.allItems[ind]!.id, gives an error
                    id: cart.allItems.values.toList()[ind].id,
                    price: cart.allItems.values.toList()[ind].price,
                    quantity: cart.allItems.values.toList()[ind].quantity,
                    title: cart.allItems.values.toList()[ind].title,
                  );
                },
              ))
            ])));
  }
}
