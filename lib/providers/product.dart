import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id, title, imageUrl, description;
  final double price;
  bool isFav;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    this.isFav = false,
  });

  void toggleFav() {
    isFav = !isFav;
    notifyListeners();
  }
}

class Products with ChangeNotifier {
  // List<Product> _prods = [ // actually use this once user input
  // // sets in
  final List<Product> _prods = [
    Product(
      id: 'p1',
      title: 'Headset',
      description: 'A quality headset - It has the best sound quality ever!',
      price: 104.99,
      imageUrl:
          'https://images.unsplash.com/photo-1484704849700-f032a568e944?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80',
    ),
    Product(
      id: 'p2',
      title: 'Iphone 11',
      description: 'An iphone with a wrist watch with matching colors',
      price: 255.99,
      imageUrl:
          'https://images.unsplash.com/photo-1592910147752-5e0bc5f04715?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80',
    ),
    Product(
      id: 'p3',
      title: 'Capture It',
      description: 'Warm and cozy - Able to relive all the best memories',
      price: 19.99,
      imageUrl:
          'https://images.unsplash.com/photo-1508723968679-b88584ef742c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
    ),
    Product(
      id: 'p4',
      title: 'Macbook Pro',
      description: 'The latest macbook pro. Has so many cool features',
      price: 749.99,
      imageUrl:
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1626&q=80',
    ),
  ];

  List<Product> get prods {
    return [..._prods];
  }

  List<Product> get favProds {
    return _prods.where((elem) => elem.isFav == true).toList();
  }

  Product findbyId(String id) {
    return prods.firstWhere((elem) => elem.id == id);
  }
}
