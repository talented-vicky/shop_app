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
