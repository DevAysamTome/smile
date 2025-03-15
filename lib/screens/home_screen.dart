import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smileapp/providers/cart_provider.dart';
import 'package:smileapp/screens/product_details.dart';
import 'package:smileapp/widgets/custom_button.dart';
import '../providers/categories_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/promo_slider.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentIndex = 0;
  bool isSearch = false;
  List<String> promoImages = [
    'https://www.shutterstock.com/image-vector/80-percent-off-discount-creative-260nw-1980213830.jpg',
    'https://t4.ftcdn.net/jpg/02/08/70/39/360_F_208703906_nUdO5KmiiQrGEXAQihVazt92XiwAGD1t.jpg',
    'https://img.freepik.com/free-vector/realistic-beauty-sale-banner-design_52683-92668.jpg?semt=ais_hybrid',
  ];
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.products;

    final filteredProducts = products.where((product) {
      if (_searchQuery.isEmpty) return true;
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // تغليف الشاشة كلها بـ Directionality لفرض RTL
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildCustomAppBar(),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushNamed(context, '/cart');
                break;
              case 2:
                Navigator.pushNamed(context, '/explore-screen');
                break;
              case 3:
                Navigator.pushNamed(context, '/favorites');
                break;
            }
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade300, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: kToolbarHeight + 100),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  !isSearch
                      ? Column(
                          children: [
                            _buildCategorySection(categoriesProvider),
                            PromoSlider(images: promoImages),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  const Text(
                                    'وصلنا حديثاَ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      // الانتقال إلى شاشة أخرى لعرض الكل
                                      Navigator.pushNamed(
                                          context, '/explore-screen');
                                    },
                                    child: Text(
                                      'عرض الكل',
                                      style:
                                          TextStyle(color: Colors.deepPurpleAccent),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildFeaturedSection(productsProvider),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildGridView(filteredProducts),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(List products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // عدد الأعمدة
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // معلومات المنتج
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // سعر وزر
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${product.price.toStringAsFixed(2)} ₪',
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 6),
          // زر التفاصيل أو الإضافة للسلة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                // لون الخط والسمك
                side: BorderSide(color: Colors.deepPurple.shade300, width: 2),
                // خلفية بيضاء
                backgroundColor: Colors.white,
                // لون النص والأيقونات
                foregroundColor: Colors.deepPurple.shade300,
                // شكل الزر (حواف مستديرة مثلاً)
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                // ارتفاع وعرض افتراضيين
                minimumSize: Size(double.infinity, 36),
              ),
              child: Text('أضف للسلة'),
              onPressed: () {
                cartProvider.addProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تمت إضافة المنتج إلى السلة')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(150), // ارتفاع كلي للـ AppBar
    child: AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,

      // نضيف flexibleSpace كي يظهر خلف العنوان والعناصر
      flexibleSpace: ClipRRect(

        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        child: Lottie.asset(
          'assets/animation.json',
          fit: BoxFit.cover,
          
        ),

      ),

      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/favorites'),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {
                // شاشة التنبيهات
              },
            ),
            const Spacer(),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/smile_logo.jpeg'),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
      centerTitle: false,

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن منتج...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                isSearch = false;
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isSearch = true;
                        _searchQuery = value;
                      });
                    },
                    // onTapOutside متوفر في إصدارات Flutter الحديثة (3.7+)
                    onTapOutside: (event) => setState(() {
                      isSearch = false;
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildCategorySection(CategoriesProvider categoriesProvider) {
    final categories = categoriesProvider.categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'تسوّق حسب التصنيف',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 100,
          child: categoriesProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    return CategoryItem(category: cat);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(ProductsProvider productsProvider) {
    if (productsProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final products = productsProvider.products;
    if (products.isEmpty) {
      return Center(child: Text('لا يوجد منتجات مميزة حالياً.'));
    }
    return Container(
      height: 360,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          final product = products[index];
          // استخدم ProductCard من المكتبة بدلاً من بطاقتك اليدوية
          return Container(
            width: 220,
            margin: EdgeInsets.only(right: 8),
            child: ProductCardWithButtons(
              product: product,
            ),
          );
        },
      ),
    );
  }
}
