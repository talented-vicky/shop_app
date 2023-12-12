import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

import '../widgets/user_prod_item.dart';
import '../widgets/nav_drawer.dart';
import '../views/edit_product.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user';

  Future<void> _prodRefresh(BuildContext ctxt) async {
    // nb: an async always returns a future hence I
    // wouldn't need to return from the function
    await Provider.of<Products>(ctxt, listen: false).getProduct();
  }

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
                // here I'm not passing any argument to the route hence
                // loading this will fail without the if check in ediProd page
                icon: const Icon(Icons.add))
          ]),
      drawer: const NavDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _prodRefresh(context),
        child: ListView.builder(
            itemCount: product.prods.length,
            itemBuilder: (BuildContext context, int ind) => Column(children: [
                  UserProductItem(
                    id: product.prods[ind].id,
                    title: product.prods[ind].title,
                    image: product.prods[ind].imageUrl,
                  ),
                  const Divider()
                ])),
      ),
    );
  }
}
