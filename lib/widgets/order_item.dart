import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart' as orderitem;

class OrderItem extends StatefulWidget {
  // viewing prod details is a stateful stuff, hence no need
  // for a provider since it's merely concerned with the ui
  // i.e it only affects this widget (so it's local) and
  // isn't tied to other widgets
  final orderitem.OrderItem order;

  const OrderItem({
    super.key,
    required this.order,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _moreitem = false;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height:
            _moreitem ? min(widget.order.cartproducts.length * 60, 120) : 85,
        // card was the initial container before animatedContainer
        // was introduced
        child: Card(
            child: Column(children: [
          ListTile(
            title: Text('\$${widget.order.totalAmount}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                Text(DateFormat('dd/MM/yyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
                onPressed: () => setState(() => _moreitem = !_moreitem),
                icon: Icon(_moreitem ? Icons.expand_less : Icons.expand_more)),
          ),
          // if (_moreitem)
          //   // if expanded arrow is clicked, then I show details
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            // height: min(widget.order.cartproducts.length * 20, 120),
            height:
                _moreitem ? min(widget.order.cartproducts.length * 20, 150) : 0,
            child: ListView(
                children: widget.order.cartproducts
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.title),
                            Text('\$${e.price}  Qty: ${e.quantity}x')
                          ],
                        ))
                    .toList()),
          )
        ])),
      );
}
