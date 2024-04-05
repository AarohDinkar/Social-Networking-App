import 'package:flutter/material.dart';
import 'package:socialskills/model/product.dart';

class Shop extends ChangeNotifier {
  // products for sale
  final List<Product> _shop = [
    

    //product 2
    Product(
      name: "Product 1",
      price: 200,
      description: 'Receives signals from satellites to provide precise location and time information.',
      textColor: Colors.black,
      imagePath: 'assets/gps.jpg',
    ),

    //product 3
    Product(
      name: "Product 2",
      price: 550,
      description: 'Open-source electronics platform based on the ESP8266 Wi-Fi module, commonly used for IoT and DIY projects.', 
      textColor: Colors.black,
      imagePath: 'assets/nodemcu.jpg',
    ),

    //product 4
    Product(
      name: "Product 3",
      price: 125,
      description: 'Measures distances or detects objects using high-frequency sound waves.', 
      textColor: Colors.black,
      imagePath: 'assets/ur.jpeg',
    ),
  ];

  // user cart
  final List<Product> _cart = [];

  // get product list
  List<Product> get shop => _shop;

  // add user cart
  List<Product> get cart => _cart;

  // add item to cart
  void addToCart(Product item) {
    _cart.add(item);
  }

  // remove item from cart
  void removeFromCart(Product item) {
    _cart.remove(item);
  }
}
