import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/product.dart';
import './providers/cart.dart';
import './providers/order.dart';

import './views/auth_page.dart';
import './views/products_page.dart';
import './views/product_detail.dart';
import './views/order_page.dart';
import './views/cart_page.dart';
import './views/user_products.dart';
import './views/edit_product.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // (3) this is the parent of "Products" and finally
  // a provider is found here; the "ChangeNotifierProvider"
  // which provided an instance of class "ProductP" in the create
  // parameter, which is also what is being listened for by
  // the Provider.of<"ProductP">(ctxt)

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctxt) => Auth()), //a
          // ChangeNotifierProvider(create: (ctxt) => Products()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctxt, auth, prevProd) => Products(
              authToken: auth.fetchToken,
              userId: auth.fetchUserId,
              prodList: prevProd == null ? [] : prevProd.prodList,
            ),
            create: (_) => Products(
              authToken: '',
              userId: '',
              prodList: [],
            ),
          ),
          // 1st <>param tells what it depends on to rebuild
          // 2nd angle param tells what will be rebuilt, added
          // prevProd as required in model to ensure I don't lose
          // product list when auth changes
          ChangeNotifierProvider(create: (ctxt) => Cart()),
          // ChangeNotifierProvider(create: (ctxt) => Order())
          ChangeNotifierProxyProvider<Auth, Order>(
              update: (ctxt, auth, prevOrder) => Order(
                  authToken: auth.fetchToken,
                  orders: prevOrder == null ? [] : prevOrder.orders),
              create: (_) => Order(authToken: '', orders: []))
        ],
        child: Consumer<Auth>(builder: (ctxt, auth, ch) {
          // ch is usually needed if I have a static part
          // or fixed widget I don't wanna rebuild
          // BTW, I've now made sure the widget below only rebuilds
          // if and only if the Auth() provider rebuilds, usually
          // indicated by notifylisteners
          return MaterialApp(
            title: "devApp", // what'll show on the app icon gangan
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.green,
                primaryColor: const Color.fromARGB(255, 6, 212, 195),
                fontFamily: 'Lato'),
            home: auth.isAuth ? const ProductsPage() : const AuthPage(),
            routes: {
              ProductDetail.routename: (ctxt) => const ProductDetail(),
              CartPage.routeName: (ctxt) => const CartPage(),
              OrderPage.routeName: (ctxt) => const OrderPage(),
              UserProducts.routeName: (ctxt) => const UserProducts(),
              EditProduct.routeName: (ctxt) => const EditProduct(),
            },
          );
        }));
  }
}

// state is simply dynamic data which affects UI