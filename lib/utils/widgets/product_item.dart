import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String img, title;
  const ProductItem({super.key, required this.img, required this.title});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black26,
              title: Text(title),
              leading: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_border)),
              trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart_outlined)),
            ),
            child: Image.network(img, fit: BoxFit.cover),
          ),
        ),
      );
}
