import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title, image;
  const UserProductItem({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) => ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(image)),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () {},
            icon:
                Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
          )
        ]),
      ));
}
