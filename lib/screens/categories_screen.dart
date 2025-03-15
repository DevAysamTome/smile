import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smileapp/data/models/category.dart';
import 'package:smileapp/providers/categories_provider.dart';
// تأكد من استيراد ملف CategoriesProvider المناسب الذي يحتوي على قائمة التصنيفات

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // جلب قائمة التصنيفات من خلال المزوّد
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final categories = categoriesProvider.categories;  // يفترض أن categories هي List<Category>

    return Scaffold(
      appBar: AppBar(
        title: Text('التصنيفات'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.name),  // عرض اسم التصنيف
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // عند النقر، الانتقال إلى شاشة المنتجات الخاصة بالتصنيف
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryProductsScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// شاشة المنتجات الخاصة بالتصنيف (كمثال مختصر)
class CategoryProductsScreen extends StatelessWidget {
  final Category category;
  const CategoryProductsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('منتجات ${category.name}')),
      body: Center(child: Text('هنا تظهر منتجات التصنيف ${category.name}')),
    );
  }
}
