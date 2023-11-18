import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final dynamic id;
  final String title, imageUrl, description;
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

  Future<void> getProduct() async {
    final url = Uri.parse(
        "https://shop-app-73a49-default-rtdb.firebaseio.com/getproducts.json");
    try {
      final data = await http.get(url);
      print(data);
    } catch (error) {
      throw error;
      // I have to throw peradventure I need to display any form
      // of error info to the user
    }
  }

  Future<void> addProduct(Product prodDetail) async {
    var url = Uri.parse(
        "https://shop-app-73a49-default-rtdb.firebaseio.com/addproducts.json");
    try {
      final postRes = await http.post(
        url,
        body: json.encode({
          'id': prodDetail.id,
          'title': prodDetail.title,
          'price': prodDetail.price,
          'derscription': prodDetail.description,
          'isFav': prodDetail.isFav,
        }),
      );
      print(postRes);
      final firebaseID = json.decode(postRes.body)['name'];

      final newProd = Product(
        id: firebaseID,
        title: prodDetail.title,
        imageUrl: prodDetail.imageUrl,
        description: prodDetail.description,
        price: prodDetail.price,
      );
      _prods.add(newProd);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateOne(String prodId, Product prodDetail) {
    final prodInd = _prods.indexWhere((elem) => elem.id == prodId);
    if (prodInd >= 0) {
      // recall this would give -1 if it doesn't find product
      _prods[prodInd] = prodDetail;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteOne(String prodId) {
    _prods.removeWhere((elem) => elem.id == prodId);
    notifyListeners();
  }
}
