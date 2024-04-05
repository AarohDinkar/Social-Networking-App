import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialskills/components/drawer1.dart';
import 'package:socialskills/components/product_tile.dart';
import 'package:socialskills/model/shop.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Shop Page"),
        actions: [
          // Go to cart button
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart_page'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      drawer: const MyDrawer1(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          const SizedBox(height: 25),
          // Shop subtitle
          const Center(
            child: Text(
              "Pick from a selected list of products",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          // Product list
          SizedBox(
            height: 550,
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                // Get each individual product from shop
                final product = products[index];

                // Return as a product tile UI
                return MyProductTile(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
