import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_cart/src/cart/models/cart_item.dart';

class AppOrder {
  final String? id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String shippingAddress;
  final DateTime createdAt;

  AppOrder({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory AppOrder.fromMap(Map<String, dynamic> map, {String? docId}) {
    return AppOrder(
      id: docId,
      userId: map['userId'],
      items: (map['items'] as List)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      shippingAddress: map['shippingAddress'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
