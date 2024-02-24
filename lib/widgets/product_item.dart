import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../views/product_detail.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id, img, title;
  // const ProductItem({
  //   super.key,
  //   required this.id,
  //   required this.img,
  //   required this.title,
  // });
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    // print("won't get here by merely clicking on fav icon");
    // I'm using false cause I don't want to listen to changes
    // on this widget, just a one-time stuff
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    // I can access cart 'cause I have it provided in my main
    // dart file :: also ensuring widget doesn't rebuild when
    // changes happen in the cart file, just notifying addition
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
                    builder: (_, productData, ch) => IconButton(
                        onPressed: () => productData.toggleFav(
                            auth.fetchToken, auth.fetchUserId),
                        icon: Icon(productData.isFav
                            ? Icons.favorite
                            : Icons.favorite_border)),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      cart.addItem(product.id, product.title, product.price);
                      // whenever I click the add-to-cart button on each product
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text("Successfully Added Item to Cart"),
                          duration: const Duration(seconds: 5),
                          action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () => cart.undoItem(product.id))));
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  )),
              child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                        ProductDetail.routename,
                        // arguments: id,
                        arguments: product.id,
                        // forwarding only the id as the argument
                      ),
                  // child: Image.network(img, fit: BoxFit.cover)),
                  // child: Image.network(product.imageUrl, fit: BoxFit.cover))),
                  child: Hero(
                    tag: product.id,
                    child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: const AssetImage(
                            'assets/images/product-placeholder.png'),
                        image: NetworkImage(product.imageUrl)),
                  )))),
    );
  }
}
