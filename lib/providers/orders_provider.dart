// providers/orders_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smileapp/data/models/cart_item.dart';
import 'package:smileapp/data/models/order.dart';

class OrdersProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // قائمة الطلبات (محليًا) إذا أردت عرضها في واجهة "طلباتي"
  List<OrderItem> _orders = [];
  List<OrderItem> get orders => _orders;

  /// إضافة طلب جديد إلى Firestore
  Future<void> addOrder(List<CartItem> cartItems, double total,String name , String phoneNumber , String addressLocation) async {
    final dateTime = DateTime.now();
    try {
      // إضافة مستند جديد في مجموعة "orders"
      DocumentReference docRef = await _firestore.collection('orders').add({
        'cartItems': cartItems.map((item) => item.toMap()).toList(),
        'total': total,
        'dateTime': dateTime.toIso8601String(),
        'name':name,
        'phoneNumber':phoneNumber,
        'addressLocation':addressLocation
      });

      // إنشاء كائن Order محليًا (لو أردت الاحتفاظ به)
      final newOrder = OrderItem(
        id: docRef.id,
        cartItems: cartItems,
        total: total,
        dateTime: dateTime,
        name: name,
        phoneNumber: phoneNumber,
        addressLocation: addressLocation
      );
      _orders.add(newOrder);
      notifyListeners();
    } catch (e) {
      print('خطأ أثناء إضافة الطلب: $e');
      rethrow; // أو يمكنك إظهار رسالة خطأ للمستخدم
    }
  }

  /// جلب الطلبات (لو أردت عرضها)
  Future<void> fetchOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('orders').get();
      _orders = snapshot.docs.map((doc) {
        return OrderItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('خطأ أثناء جلب الطلبات: $e');
    }
  }
}
