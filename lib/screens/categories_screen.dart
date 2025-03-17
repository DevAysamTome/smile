import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/category.dart';
import '../data/models/product.dart';
import '../screens/product_details.dart'; // إن أردت شاشة تفاصيل المنتج

class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  const CategoryProductsScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  bool loading = true;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('products')
          .where('categoryId', isEqualTo: widget.category.id)
          .get();

      final fetchedProducts = snap.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          discount: (data['discount'] ?? 0.0).toDouble(),
          sizes: data['sizes'] == null ? [] : List<String>.from(data['sizes']),
          imageUrl: data['imageURL'] ?? '',
          category: data['categoryId'] ?? '',
          description: data['description'] ?? '',
          images: data['images'] == null ? [] : List<String>.from(data['images']),
          oldPrice: (data['oldPrice'] ?? 0.0).toDouble(),
        );
      }).toList();

      setState(() {
        products = fetchedProducts;
        loading = false;
      });
    } catch (e) {
      print('خطأ في جلب منتجات الصنف: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // نغلف الشاشة بـ Directionality لجعلها RTL
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // اجعل العنوان في المنتصف
          centerTitle: true,
          title: Text(
            'منتجات ${widget.category.name}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepOrange.shade300,
          iconTheme: const IconThemeData(color: Colors.white), // يجعل أيقونة العودة بلون أبيض
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrangeAccent.shade100, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
                  ? const Center(child: Text('لا توجد منتجات في هذا الصنف'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      // تصميم الشبكة: عمودان، مسافة بين الخلايا 8
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        // تحكم في نسبة العرض إلى الارتفاع للخلايا
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products.length,
                      itemBuilder: (ctx, index) {
                        final product = products[index];
                        return _buildProductCard(product);
                      },
                    ),
        ),
      ),
    );
  }

  // عنصر البطاقة في الشبكة
  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // الانتقال لشاشة تفاصيل المنتج
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white70,
                          size: 48,
                        ),
                      ),
              ),
            ),
            // معلومات المنتج
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price} ₪',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
