import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialskills/firebase_options.dart';
import 'package:socialskills/model/shop.dart';
import 'package:socialskills/pages/auth.dart';
import 'package:socialskills/pages/cart_page.dart';
import 'package:socialskills/pages/intro_page.dart';
import 'package:socialskills/pages/shop_page.dart';
import 'package:socialskills/theme/dark_theme.dart';
import 'package:socialskills/theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Shop()),
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
       routes: {
        '/intro_page':(context) => const IntroPage(),
        '/shop_page':(context) => const ShopPage(),
        '/cart_page':(context) => const CartPage(),
      },
    );
  }
}
