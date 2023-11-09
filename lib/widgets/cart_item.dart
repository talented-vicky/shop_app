import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id, title;
  final double price;
  final int quantity;
  const CartItem(
      {super.key,
      required this.id,
      required this.title,
      required this.price,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
        key: ValueKey(id),
        onDismissed: (_) {
          cart.removeItem(id);
        },
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) => showDialog(
            context: context,
            builder: (ctxt) => AlertDialog(
                    title: const Text("Delete Cartitem"),
                    content: const Text(
                        "Deleting this cart item from the order cannot be undone"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctxt).pop(false),
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctxt).pop(true),
                        child: const Text("Yes"),
                      ),
                    ])),
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 40),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                  child: FittedBox(
                      child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('\$$price'),
              ))),
              trailing: Text('$quantity x'),
              title: Text(title),
              subtitle: Text('Total: ${(price * quantity)}'),
            ),
          ),
        ));
  }
}
