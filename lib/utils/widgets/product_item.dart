import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product.dart';
import '../../views/product_detail.dart';

class ProductItem extends StatelessWidget {
  // final String id, img, title;
  // const ProductItem({
  //   super.key,
  //   required this.id,
  //   required this.img,
  //   required this.title,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    print("won't get here by merely clicking on fav icon");
    return Container(
      margin: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black26,
            title: Text(product.title),
            leading: Consumer<Product>(
              // consumer ensures only the iconbutton
              // sub-widget rebuilds whenever user clicks fav icon
              builder: (_, product, child) => IconButton(
                  onPressed: () {
                    product.toggleFav();
                  },
                  icon: Icon(
                      product.isFav ? Icons.favorite : Icons.favorite_border)),
            ),
            trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined)),
          ),
          child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                    ProductDetail.routename,
                    // arguments: id,
                    arguments: product.id,
                    // forwarding only the id as the argument
                  ),
              // child: Image.network(img, fit: BoxFit.cover)),
              child: Image.network(product.imageUrl, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
