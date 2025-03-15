// models/order.dart
import 'package:smileapp/data/models/cart_item.dart';

class OrderItem {
  final String id;
  final List<CartItem> cartItems;
  final double total;
  final DateTime dateTime;
  final String name;
  final String phoneNumber;
  final String addressLocation;
  OrderItem({
    required this.id,
    required this.cartItems,
    required this.total,
    required this.dateTime,
    required this.addressLocation,
    required this.name,
    required this.phoneNumber
  });

  // تحويل الطلب إلى خريطة (للتخزين في Firestore مثلاً)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'total': total,
      'dateTime': dateTime.toIso8601String(),
      'name': name,
      'phoneNumber':phoneNumber,
      'addressLocation':addressLocation
    };
  }

  // لو أردت بناء Order من وثيقة Firestore
  // (ليس ضروريًا إن لم تكن تعرض الطلبات للمستخدم)
  factory OrderItem.fromMap(Map<String, dynamic> data, String docId) {
    return OrderItem(
      id: docId,
      cartItems: (data['cartItems'] as List)
          .map((e) => CartItem.fromMap(e))
          .toList(),
      total: data['total'],
      dateTime: DateTime.parse(data['dateTime'],

      ),
      addressLocation: data['addressLocation'],
      name: data['name'],
      phoneNumber: data['phoneNumber']
    );
  }
}
