import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

import '../widgets/user_prod_item.dart';
import '../widgets/nav_drawer.dart';
import '../views/edit_product.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user';
  const UserProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
          title:
              const Text("My Products", style: TextStyle(color: Colors.black)),
          forceMaterialTransparency: true,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(EditProduct.routeName),
                icon: const Icon(Icons.add))
          ]),
      drawer: const NavDrawer(),
      body: ListView.builder(
        itemCount: product.prods.length,
        itemBuilder: (BuildContext context, int ind) => Column(
          children: [
            UserProductItem(
              title: product.prods[ind].title,
              image: product.prods[ind].imageUrl,
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
