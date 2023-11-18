import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../views/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String id, title, image;
  const UserProductItem({
    super.key,
    required this.id,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) => ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(image)),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProduct.routeName, arguments: id),
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctxt) => AlertDialog(
                    title: const Text("Delete Product!"),
                    content: const Text(
                        'This is an irreversible action, and will remove product from database'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctxt).pop();
                          Provider.of<Products>(context, listen: false)
                              .deleteOne(id);
                        },
                        child: const Text('Confirm Delete'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctxt).pop();
                        },
                        child: const Text('Abort'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.error))
        ]),
      ));
}
