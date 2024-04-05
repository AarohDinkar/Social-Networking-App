import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialskills/components/button1.dart';
import 'package:socialskills/model/product.dart';
import 'package:socialskills/model/shop.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key});

  // Remove item from cart
  void removeItemFromCart(BuildContext context, Product product) {
    // Show a dialog box to ask the user to confirm removing the item from the cart
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Remove this item from your cart?"),
        actions: [
          // Cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // Yes button
          MaterialButton(
            onPressed: () {
              // Pop the dialog box
              Navigator.pop(context);

              // Remove from cart
              context.read<Shop>().removeFromCart(product);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  // User pressed pay button
  void payButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Text("Pay functionality will be added"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get access to the cart
    final cart = context.watch<Shop>().cart;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Cart"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          // Cart list
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text("Your cart is empty"))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      // Get an individual item in the cart
                      final item = cart[index];

                      // Return it as a cart tile UI
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.price.toStringAsFixed(2)),
                        trailing: IconButton(
                          onPressed: () => removeItemFromCart(context, item),
                          icon: const Icon(Icons.remove),
                        ),
                      );
                    },
                  ),
          ),

          // Pay button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MyButton1(
              onTap: () => payButtonPressed(context),
              child: const Text("Pay now"),
            ),
          ),
        ],
      ),
    );
  }
}
