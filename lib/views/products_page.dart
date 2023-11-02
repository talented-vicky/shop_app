import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_gridview.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FavEnum { favoriteProds, allProds }

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // (2) this is the parent of "productGridView" but no provider

  var showFav = false;
  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context);
    // I don't need that since it's only the badge that needs
    // to listen to changes, hence I should avoid unnecesary
    // rebuild of this widget
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text("Menu", style: TextStyle(color: Colors.black)),
          leading: const Icon(Icons.home, color: Colors.black),
          actions: [
            PopupMenuButton(
              color: Colors.black,
              onSelected: (FavEnum val) {
                setState(() {
                  if (val == FavEnum.favoriteProds) {
                    showFav = true;
                  } else {
                    showFav = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert_rounded),
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: FavEnum.favoriteProds,
                  child:
                      Text("Favourite", style: TextStyle(color: Colors.white)),
                ),
                PopupMenuItem(
                  value: FavEnum.allProds,
                  child: Text("All", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
            Consumer<Cart>(
                builder: (_, cartData, ch) => CartBadge(
                      baby: ch!,
                      value: cartData.itemCount.toString(),
                    ),
                child:
                    // this child gets passed into the 3rd argument of
                    // the consumer builder argument, passing it into
                    // child outside of the builder ensures it doesn't
                    // rebuild when Cart changes
                    IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                  ),
                ))
          ]),
      body: ProductGridview(checkFav: showFav),
    );
  }
}
