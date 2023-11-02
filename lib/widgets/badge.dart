import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final Widget baby;
  final String value;
  final Color color;

  const CartBadge({
    super.key,
    required this.baby,
    required this.value,
    this.color = Colors.grey,
    // I've set a default grey color
  });

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.center, children: [
        baby,
        Positioned(
            right: 4,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                // color: Theme.of(context).accentColor,
                color: color,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10)),
            ))
      ]);
}
