import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});
  static const routename = '/detail';

  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context)!.settings.arguments as String;
    // becauase I only forwarded the id as the argument, so
    // fetching off of settings will yield the id
    final product = Provider.of<Products>(
      context,
      listen: false,
      // b'cos fetching a product detail is a one-time action,
      // hence need not update, UNLIKE in GRIDVIEW, casue a user
      // can add or remove a product at any time
    ).findbyId(prodId);

    return Scaffold(
      appBar: AppBar(
        title: Text(prodId),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(product.description), Text(product.price.toString())],
      ),
    );
  }
}
