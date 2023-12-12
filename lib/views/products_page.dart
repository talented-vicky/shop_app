import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_gridview.dart';
import '../widgets/badge.dart';
import '../widgets/nav_drawer.dart';

import '../views/cart_page.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

enum FavEnum { favoriteProds, allProds }

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // (2) this is the parent of "productGridView" but no provider

  var _showFav = false;
  var _isLoading = false;

  @override
  void initState() {
    // doens't support listening cause may pointlessly
    // rebuild the widget associated with the event handler
    // although the widget tree doesn't care about it
    setState(() => _isLoading = true);
    Future.delayed(Duration.zero)
        .then((_) => Provider.of<Products>(context, listen: false).getProduct())
        .then((value) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context)
      // final cart = Provider.of<Cart>(context);
      // I don't need that since it's only the badge that needs
      // to listen to changes, hence I should avoid unnecesary
      // rebuild of this widget
      =>
      Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            title: const Text("Menu", style: TextStyle(color: Colors.black)),
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              PopupMenuButton(
                onSelected: (FavEnum val) {
                  setState(() {
                    if (val == FavEnum.favoriteProds) {
                      _showFav = true;
                      // trigger this on the backend I guess
                    } else {
                      _showFav = false;
                    }
                  });
                },
                icon: const Icon(Icons.more_vert_rounded),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: FavEnum.favoriteProds,
                    child: Text("Favourite",
                        style: TextStyle(color: Colors.black)),
                  ),
                  PopupMenuItem(
                    value: FavEnum.allProds,
                    child: Text("All", style: TextStyle(color: Colors.black)),
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
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartPage.routeName),
                    icon: const Icon(Icons.shopping_bag_outlined),
                  ))
            ]),
        drawer: const NavDrawer(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ProductGridview(checkFav: _showFav),
      );
}
