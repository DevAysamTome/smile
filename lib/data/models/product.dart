import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double oldPrice;
  final String description;
  final String imageUrl;
  final String category;
  final double discount;
  final List<String> images;
  final bool isAvailable;
  final int quantity; 
  // 🟢 الأحجام: قائمة من SizeOption
  final List<SizeOption> sizes;

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
    required this.images,
    required this.isAvailable,
    required this.quantity,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // نقرأ حقل sizes كقائمة كائنات [{name, price}, ...]
    final rawSizes = data['sizes'] as List<dynamic>? ?? [];
    final fetchedSizes = rawSizes.map((e) {
      // كل عنصر e هو Map<String, dynamic>
      return SizeOption.fromMap(e as Map<String, dynamic>);
    }).toList();

    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      oldPrice: (data['oldPrice'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      imageUrl: data['imageURL'] ?? '',
      category: data['categoryId'] ?? '',
      discount: (data['discount'] ?? 0.0).toDouble(),
      images: data['images'] == null
          ? []
          : List<String>.from(data['images']),
      sizes: fetchedSizes,
       isAvailable: data['isAvailable'] ?? true,
      quantity: data['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'oldPrice': oldPrice,
      'description': description,
      'imageURL': imageUrl,
      'categoryId': category,
      'discount': discount,
      'images': images,
      // تحويل قائمة SizeOption إلى قائمة Maps
      'sizes': sizes.map((s) => s.toMap()).toList(),
      'isAvailable':isAvailable,
      'quantity':quantity
    };
  }
}

class SizeOption {
  final String name;
  final double price;

  SizeOption({required this.name, required this.price});

  // factory لتسهيل التحويل من Map إلى SizeOption
  factory SizeOption.fromMap(Map<String, dynamic> map) {
    return SizeOption(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  // اختياري: تحويل SizeOption إلى Map (إن أردت حفظه مجددًا في Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}
