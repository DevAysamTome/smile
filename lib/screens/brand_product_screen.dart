import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smileapp/data/models/brand.dart';
import 'package:smileapp/data/models/product.dart';
import 'package:smileapp/widgets/product_card.dart';

class BrandProductsScreen extends StatefulWidget {
  final Brand brand;

  const BrandProductsScreen({Key? key, required this.brand}) : super(key: key);

  @override
  _BrandProductsScreenState createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  bool loading = true;
  List<Product> products = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBrandProducts();
  }

  Future<void> _fetchBrandProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('brandId', isEqualTo: widget.brand.id)
          .orderBy('name') // ترتيب المنتجات بالأبجدية
          .get();

      final fetchedProducts = querySnapshot.docs.map(Product.fromFirestore).toList();

      setState(() {
        products = fetchedProducts;
        loading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'حدث خطأ أثناء جلب المنتجات. يرجى المحاولة لاحقًا.';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          title: Text(
            'منتجات ${widget.brand.name}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text(errorMessage!, style: const TextStyle(fontSize: 18, color: Colors.red)))
                  : products.isEmpty
                      ? Center(
                          child: Text(
                            'لا توجد منتجات لهذه الماركة',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                            double childAspectRatio = constraints.maxWidth > 600 ? 0.8 : 0.7;

                            return GridView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: products.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing:8,
                                crossAxisSpacing: 8,
                                childAspectRatio: childAspectRatio,
                              ),
                              itemBuilder: (ctx, index) => ProductCardWithButtons(product: products[index]),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
