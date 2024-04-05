import 'package:flutter/material.dart';
import 'package:socialskills/components/button1.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            const Icon(
              Icons.shopping_bag,
              size: 72,
              color: Colors.black,
            ),

            const SizedBox(height: 25),
        
            // title
            const Text("Marketplace",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            ),

            const SizedBox(height: 10),

            //subtitle
            const Text("Premium quality products",
            style: TextStyle(
              color: Colors.black,
            ),
            ),

            const SizedBox(height: 25),

            //button
            MyButton1(
              onTap: () => Navigator.pushNamed(context, '/shop_page'),
             child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}