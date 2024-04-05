import 'package:flutter/material.dart';
import 'package:socialskills/components/my_list_tile.dart';

class MyDrawer1 extends StatelessWidget {
  const MyDrawer1({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header: logo

              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: 72,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // shop tile
              MyListTile(
                  icon: Icons.home,
                  onTap: () => Navigator.pop(context),
                  text: "S H O P"),

              // cart tile
              MyListTile(
                  icon: Icons.shopping_cart,
                  onTap: () {
                    //pop drawer first
                    Navigator.pop(context);

                    // go to cart page
                    Navigator.pushNamed(context, '/cart_page');
                  },
                  text: "C A R T"),
            ],
          ),

          // exit shop tile
           Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(
              icon: Icons.logout,
               onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/intro_page', (route) => false),
                text: "E X I T"),
          ),
          
        ],
      ),
    );
  }
}