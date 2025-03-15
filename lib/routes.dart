import 'package:flutter/material.dart';
import 'package:smileapp/app.dart';
import 'package:smileapp/data/models/product.dart';
import 'package:smileapp/screens/favorites_screen.dart';
import 'package:smileapp/screens/product_details.dart';
import 'package:smileapp/screens/splash_screen.dart';
import 'package:smileapp/screens/explore_screen.dart';
import 'screens/home_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_success.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => SplashScreen(),
  '/home': (context) => HomeScreen(),

  '/favorites': (context) => FavoritesScreen(),

  '/categories': (context) => CategoriesScreen(),
  '/cart': (context) => CartScreen(),
  '/checkout': (context) => CheckoutScreen(),
  '/order-success': (context) => OrderSuccessScreen(),
  '/explore-screen': (context) => ExploreScreen(),
};

// مسار ديناميكي لشاشة تفاصيل المنتج
Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == '/product-details') {
    // بدلاً من cast إلى Map<String, dynamic>، استخدم cast إلى Product
    final product = settings.arguments as Product;
    return MaterialPageRoute(
      builder: (context) => ProductDetailsScreen(product: product),
    );
  }
  return MaterialPageRoute(builder: (context) => HomeScreen());
}
