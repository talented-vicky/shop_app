import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';

class ProductGridview extends StatelessWidget {
  final bool checkFav;
  const ProductGridview({super.key, required this.checkFav});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    // I am able to listen (with "Provider.of(ctxt)", at
    // "ProductP" widget) because a direct/indirect parent of
    // this widget already has provider set in it (main.dart in
    // this case using "ChangeNotifierProvider")

    // (1) now the "ss" checks the parent of "productGridView"
    // for a provider
    final products = checkFav ? productsData.favProds : productsData.prods;

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of columns
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int ind) =>
            ChangeNotifierProvider.value(
              value: products[ind],
              // I don't want to rebuild (in this case re'create')
              // because I already have the "Products" fetched
              // and I need just a single product actually, hence
              // indexing is key,

              // note I'm using .value instead since I'm working with a
              // grid/list/collction of different elements which
              // already exist... as oppposed to how I used
              // the changeNotifierProvider in the main.dart file

              // ChangeNotifierProvider(
              // create: (ctxt) => Products(), so this'd be unnecessary
              child: ProductItem(
                  // img: myProd[ind].imageUrl ??= null ? myProd[ind].imageUrl : "No image here",
                  // id: products[ind].id,
                  // img: products[ind].imageUrl,
                  // title: products[ind].title,
                  // I no longer need to pass arguments since I'm using
                  // a provider
                  ),
            ));
  }
}
