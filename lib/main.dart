import 'package:smileapp/providers/colorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smileapp/core/scroll_behavior.dart';
import 'package:smileapp/firebase_options.dart';
import 'package:smileapp/providers/brands_provider.dart';
import 'package:smileapp/providers/categories_provider.dart';
import 'package:smileapp/providers/favorites_provider.dart';
import 'package:smileapp/routes.dart';
import 'package:smileapp/utils/add.dart';
import 'providers/products_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';

import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider()..fetchInitialProducts(),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(
          create: (_) => CategoriesProvider()..fetchCategories(),
        ),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ColorsProvider()..fetchColors()),
        ChangeNotifierProvider(create: (_) => BrandsProvider()..fetchBrands()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ALORA',
        theme: AppTheme.lightTheme,
        scrollBehavior: MyCustomScrollBehavior(),
        initialRoute: '/',
        routes: appRoutes,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
