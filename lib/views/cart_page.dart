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
                            OrderButton(cart: cart)
                          ]))),
              Expanded(
                  child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (BuildContext context, int ind) => CartItem(
                  // id: cart.allItems[ind]!.id, gives an error
                  id: cart.allItems.values.toList()[ind].id,
                  price: cart.allItems.values.toList()[ind].price,
                  quantity: cart.allItems.values.toList()[ind].quantity,
                  title: cart.allItems.values.toList()[ind].title,
                ),
              ))
            ])));
  }
}

class OrderButton extends StatefulWidget {
  OrderButton({super.key, required this.cart});

  final Cart cart;
  bool _isLoading = false;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) => TextButton(
      // disable button if total amount in cart is 0
      // or isloading state is true
      onPressed: widget.cart.totalAmount == 0 || widget._isLoading
          ? null
          : () async {
              try {
                setState(() => widget._isLoading = true);
                await Provider.of<Order>(context, listen: false).placeOrder(
                    widget.cart.allItems.values.toList(),
                    widget.cart.totalAmount);
                widget.cart.clearCart();
                setState(() => widget._isLoading = false);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error Placing Order")));
              }
            },
      child: widget._isLoading
          ? const CircularProgressIndicator()
          : Text(
              "Order Now!",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ));
}
