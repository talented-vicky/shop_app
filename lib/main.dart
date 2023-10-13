import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './views/products_page.dart';
import './views/product_detail.dart';
import './providers/products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // (3) this is the parent of "Products" and finally
  // a provider is found here; the "ChangeNotifierProvider"
  // which provided an instance of class "ProductP" in the create
  // parameter, which is also what is being listened for by
  // the Provider.of<"ProductP">(ctxt)

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (ctxt) => Products(),
        child: MaterialApp(
          title: "devApp", // what'll show on the app icon gangan
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Colors.amberAccent,
            fontFamily: 'Lato',
          ),
          home: const ProductsPage(),
          routes: {
            ProductDetail.routename: (ctxt) => const ProductDetail(),
          },
        ),
      );
}

// state is simply dynamic data which affects UI
// home page should have search (extreme right) and 
// logo (left) alone