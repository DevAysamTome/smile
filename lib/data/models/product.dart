import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  double oldPrice;
  final String description;
  final String imageUrl;
  final String category;
final double discount;
final List<String> images;
  /// 🟢 أضف هذا الحقل للأحجام
  final List<String> sizes;  // أو List<String>? إذا أردت السماح بالقيم الفارغة

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.oldPrice,
    required this.category,
    required this.sizes, 
    required this.discount,
    required this.images// تأكد من إضافته أيضًا في constructor
  });

  /// 🟢 **تحويل بيانات Firestore إلى كائن `Product`**
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // إذا أردت جلب الأحجام من Firestore (قائمة من String)
    // تأكد أن الحقل في الداتا اسمه "sizes" (مثلاً List<String>)
    final List<String> fetchedSizes = [];
    if (data['sizes'] != null) {
      // نفترض أنه مخزن في Firestore كمصفوفة [ "S", "M", "L" ...]
      fetchedSizes.addAll(List<String>.from(data['sizes']));
    }

    return Product(
      id: doc.id,
      name: data['name'] ?? 'No Name',
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
      oldPrice: (data['oldPrice'] ?? 0.0).toDouble(),
      category: data['categoryId'] ?? '',
      sizes: fetchedSizes,
      discount: (data['discount'] ?? 0.0).toDouble(),
images: data['images'] == null ? [] : List<String>.from(data['images']), // نمرر الأحجام التي جلبناها
    );
  }

  /// 🔵 **تحويل كائن `Product` إلى JSON لحفظه في Firestore**
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'oldPrice': oldPrice,
      'categoryId': category,
      'sizes': sizes, // لو أردت حفظ الأحجام في Firestore أيضًا
    };
  }
}
