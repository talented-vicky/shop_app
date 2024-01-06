import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/order_page.dart';
import '../views/user_products.dart';
import '../providers/auth.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: Column(children: [
          AppBar(
            title:
                const Text('Welcome!', style: TextStyle(color: Colors.black)),
            shadowColor: Colors.transparent,
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ]),
      );

  // Akolawon/Adebisi
  // 08038027845
}
