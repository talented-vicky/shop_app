import 'package:flutter/material.dart';

import '../views/order_page.dart';
import '../views/user_products.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: Column(children: [
          AppBar(
            title:
                const Text('Welcome!', style: TextStyle(color: Colors.black)),
            shadowColor: Colors.transparent,
            // backgroundColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.white24,
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Orders'),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(OrderPage.routeName)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Manage Products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProducts.routeName),
          ),
        ]),
      );
}
