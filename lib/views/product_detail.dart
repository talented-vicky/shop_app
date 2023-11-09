import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});
  static const routename = '/detail';

  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context)!.settings.arguments as String;
    // becauase I only forwarded the id as the argument, so
    // fetching off of settings will yield the id

    // setting up a listener (that causes app rebuild)
    final product = Provider.of<Products>(
      context,
      listen: false,
      // b'cos fetching a product detail is a one-time action,
      // hence need not update, UNLIKE in GRIDVIEW, casue a user
      // can add or remove a product at any time
    ).findbyId(prodId);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text(product.title, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '\$${product.price}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Text(product.description.toString(), softWrap: true),
          ],
        ),
      ),
    );
  }
}
