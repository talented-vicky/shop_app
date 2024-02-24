import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final String id, imageUrl, title, desc;
  final double price;
  const ProductInfo(
      {super.key,
      required this.id,
      required this.imageUrl,
      required this.title,
      required this.price,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // return SingleChildScrollView(
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: .53 * deviceSize.height,
          // expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Details',
                style: TextStyle(color: Colors.white, fontSize: 17)),
            background: Hero(
              tag: id,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            // forceMaterialTransparency: true,
            // iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            height: 10,
            child: const Text(''),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                        Text(title, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 5),
                        Text('\$$price',
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
                    desc.toString(),
                    softWrap: true,
                    style: const TextStyle(height: 1.7, color: Colors.grey),
                  ),
                  ElevatedButton(
                      child: const Text("ADD TO CART",
                          style: TextStyle(fontSize: 12)),
                      onPressed: () {})
                ],
              )),
          const SizedBox(height: 400)
        ]))
      ],
    );
  }
}
