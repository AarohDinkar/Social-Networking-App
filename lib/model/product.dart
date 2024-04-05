import 'dart:ui';

class Product {
  final String name;
  final String description;
  final double price;
  final String imagePath;

  Product(
      {required this.name,
      required this.description,
      required this.price,
      required this.imagePath, required Color textColor,});
}
