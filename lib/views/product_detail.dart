import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});
  static const routename = '/detail';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
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
          title: const Text('Details',
              style: TextStyle(color: Colors.black, fontSize: 17)),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
            child: Stack(children: [
          Container(
            height: deviceSize.height,
            child: const Text(''),
          ),
          Column(
            children: [
              Container(
                width: deviceSize.width,
                height: .53 * deviceSize.height,
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ],
          ),
          Positioned(
              top: 280,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                height: 300,
                width: deviceSize.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(50))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 5),
                          Text('\$${product.price}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ]),
                    Container(
                        width: 250,
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Icon(Icons.shape_line_outlined),
                                Text('Material')
                              ]),
                              Column(children: [
                                Icon(Icons.auto_awesome),
                                Text('Operation')
                              ]),
                              Column(children: [
                                Icon(Icons.medical_information),
                                Text('SignalShow')
                              ]),
                            ])),
                    Text(
                      product.description.toString(),
                      softWrap: true,
                      style: const TextStyle(height: 1.7, color: Colors.grey),
                    ),
                    ElevatedButton(
                      child: const Text("ADD TO CART",
                          style: TextStyle(fontSize: 12)),
                      onPressed: () {},
                    )
                  ],
                ),
              ))
        ])));
  }
}
