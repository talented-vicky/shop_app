import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/exception.dart';

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

  Future<void> toggleFav() async {
    // saving current status in memory in case of future revert
    dynamic stat = isFav;

    isFav = !isFav;
    notifyListeners();

    final url = Uri.parse(
        "https://shop-app-73a49-default-rtdb.firebaseio.com/products.json");
    final resp = await http.patch(url, body: json.encode({'isFav': isFav}));

    if (resp.statusCode >= 400) {
      // error, so I'll revert changes
      isFav = stat;
      notifyListeners();
      throw Exceptions(msg: "Error Changing Favourite Status");
    }
  }
}

class Products with ChangeNotifier {
  List<Product> _prods = [];
  // final List<Product> _prods = [
  //   Product(
  //     id: 'p1',
  //     title: 'Headset',
  //     description: 'A quality headset - It has the best sound quality ever!',
  //     price: 104.99,
  //     imageUrl:
  //         'https://images.unsplash.com/photo-1484704849700-f032a568e944?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Iphone 11',
  //     description: 'An iphone with a wrist watch with matching colors',
  //     price: 255.99,
  //     imageUrl:
  //         'https://images.unsplash.com/photo-1592910147752-5e0bc5f04715?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Capture It',
  //     description: 'Warm and cozy - Able to relive all the best memories',
  //     price: 19.99,
  //     imageUrl:
  //         'https://images.unsplash.com/photo-1508723968679-b88584ef742c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'Macbook Pro',
  //     description: 'The latest macbook pro. Has so many cool features',
  //     price: 749.99,
  //     imageUrl:
  //         'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1626&q=80',
  //   ),
  // ];

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
        "https://shop-app-73a49-default-rtdb.firebaseio.com/products.json");
    try {
      final data = await http.get(url);
      final object = json.decode(data.body) as Map<String, dynamic>;
      final List<Product> prodList = [];

      object.forEach(
        (prodId, prodData) => prodList.add(Product(
            id: prodId,
            title: prodData['title'],
            imageUrl: prodData['imageUrl'],
            description: prodData['description'],
            price: prodData['price'])),
      );
      _prods = prodList;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
      // I have to "throw" erros peradventure I need to
      // display any form of error info to the user
    }
  }

  Future<void> addProduct(Product prodDetail) async {
    var url = Uri.parse(
        "https://shop-app-73a49-default-rtdb.firebaseio.com/products.json");
    try {
      final postRes = await http.post(url,
          body: json.encode({
            'id': prodDetail.id,
            'title': prodDetail.title,
            'price': prodDetail.price,
            'imageUrl': prodDetail.imageUrl,
            'description': prodDetail.description,
            'isFav': prodDetail.isFav,
          }));
      // the above is what I've added to firebase database

      final firebaseID = json.decode(postRes.body)['name'];
      // I'm fetching the id firebase returns & using it

      final newProd = Product(
        id: firebaseID,
        title: prodDetail.title,
        imageUrl: prodDetail.imageUrl,
        description: prodDetail.description,
        price: prodDetail.price,
      );
      _prods.add(newProd);
      // now adding the data to the local storage list

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateOne(String prodId, Product prodDetail) async {
    final prodInd = _prods.indexWhere((elem) => elem.id == prodId);
    // recall this would give -1 if it doesn't find product

    if (prodInd >= 0) {
      var url = Uri.parse(
          "https://shop-app-73a49-default-rtdb.firebaseio.com/products/$prodId.json");

      await http.patch(
        url,
        body: json.encode({
          // firebase keeps any data whose key I'm not
          // sending, like "isFav"
          'title': prodDetail.title,
          'price': prodDetail.price,
          'imageUrl': prodDetail.imageUrl,
          'description': prodDetail.description,
        }),
      );

      _prods[prodInd] = prodDetail;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteOne(String prodId) async {
    // FOR NOW, delete product Icon doesn't show the dialogue
    final url = Uri.parse(
        "https://shop-app-73a49-default-rtdb.firebaseio.com/products/$prodId.json");
    final prodInd = _prods.indexWhere((elem) => elem.id == prodId);
    dynamic prod = _prods[prodInd];
    // Storing a pointer to this product in memory

    // Removing product locally from list
    _prods.removeAt(prodInd);
    notifyListeners();

    // Removing product from firebase db, but also ensuring
    // optimistic updating
    final resp = await http.delete(url);
    if (resp.statusCode >= 400) {
      // There's an error, hence I can successfully roll
      // back the product locally into list
      _prods.insert(prodInd, prod);
      notifyListeners();
      throw Exceptions(msg: "Error Deleting Product");
    }

    // Delete request was successfull, hence I'm clearing
    // the memory of this product
    prod = null;
  }
}
