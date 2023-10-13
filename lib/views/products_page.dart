import 'package:flutter/material.dart';

import '../utils/widgets/product_gridview.dart';

enum FavEnum { favoriteProds, allProds }

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  // (2) this is the parent of "productGridView" but no provider
  // is found, so it moves to the parent of "Products"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New SApp"),
        actions: [
          PopupMenuButton(
            onSelected: (FavEnum val) {
              if (val == FavEnum.favoriteProds) {
                //
              } else {
                //
              }
            },
            icon: const Icon(Icons.more_vert_rounded),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FavEnum.favoriteProds,
                child: Text("Favourite"),
              ),
              PopupMenuItem(
                value: FavEnum.allProds,
                child: Text("All"),
              )
            ],
          )
        ],
      ),
      body: const ProductGridview(),
    );
  }
}
