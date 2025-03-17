import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smileapp/screens/categories_screen.dart';

import '../data/models/category.dart';
import '../providers/categories_provider.dart';

// شاشة تعرض قائمة التصنيفات
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // جلب قائمة التصنيفات من خلال المزوّد
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final categories = categoriesProvider.categories; // يفترض أنها List<Category>

    return Scaffold(
      appBar: AppBar(
        title: const Text('التصنيفات'),
        backgroundColor: Colors.deepOrange.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrangeAccent.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (ctx, index) {
              final category = categories[index];
              return _buildCategoryItem(context, category);
            },
          ),
        ),
      ),
    );
  }

  // عنصر تصنيف بشكل بطاقة منسّقة
  Widget _buildCategoryItem(BuildContext context, Category category) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // الانتقال لشاشة تعرض منتجات هذا الصنف
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryProductsScreen(category: category),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // إذا لديك صورة للصنف
              if (category.imageUrl != null && category.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    category.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              else
                // صورة افتراضية إن لم يوجد
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_not_supported, color: Colors.white70),
                ),
              const SizedBox(width: 16),
              // اسم التصنيف
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}