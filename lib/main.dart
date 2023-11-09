import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/product.dart';
import './providers/cart.dart';
import './providers/order.dart';

import './views/products_page.dart';
import './views/product_detail.dart';
import './views/order_page.dart';
import './views/cart_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // (3) this is the parent of "Products" and finally
  // a provider is found here; the "ChangeNotifierProvider"
  // which provided an instance of class "ProductP" in the create
  // parameter, which is also what is being listened for by
  // the Provider.of<"ProductP">(ctxt)

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctxt) => Products()),
            ChangeNotifierProvider(create: (ctxt) => Cart()),
            ChangeNotifierProvider(create: (ctxt) => Order())
          ],
          child: MaterialApp(
            title: "devApp", // what'll show on the app icon gangan
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.green,
                primaryColor: const Color.fromARGB(255, 6, 212, 195),
                fontFamily: 'Lato'),
            home: const ProductsPage(),
            routes: {
              ProductDetail.routename: (ctxt) => const ProductDetail(),
              CartPage.routeName: (ctxt) => const CartPage(),
              OrderPage.routeName: (ctxt) => const OrderPage()
            },
          ));
}

// state is simply dynamic data which affects UI
// home page should have search (extreme right) and 
// logo (left) alone




/*
C:\Users\HP\Documents\personal\php\php.exe is not a valid 
php executable. Use the setting 'php.validate.executablePath' 
to configure the PHP executable.
 */