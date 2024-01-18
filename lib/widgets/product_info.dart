import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final String imageUrl, title, desc;
  final double price;
  const ProductInfo(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.price,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Stack(children: [
      Container(
        height: deviceSize.height,
        child: const Text(''),
      ),
      Column(children: [
        Container(
          width: deviceSize.width,
          height: .53 * deviceSize.height,
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ]),
      Positioned(
          top: 280,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            height: 300,
            width: deviceSize.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(50))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  child:
                      const Text("ADD TO CART", style: TextStyle(fontSize: 12)),
                  onPressed: () {},
                )
              ],
            ),
          ))
    ]));
  }
}
