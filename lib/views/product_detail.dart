import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../widgets/product_info.dart';

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
        // appBar: AppBar(
        //   forceMaterialTransparency: true,
        //   title: const Text('Details',
        //       style: TextStyle(color: Colors.black, fontSize: 17)),
        //   iconTheme: const IconThemeData(color: Colors.black),
        // ),
        // I dont' need appBar since I wanna use slivers
        body: ProductInfo(
            id: product.id,
            imageUrl: product.imageUrl,
            title: product.title,
            price: product.price,
            desc: product.description));
  }
}
