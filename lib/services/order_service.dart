import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/models/item.dart' show Item;
import 'package:workshop_shopping_app/models/order.dart';
import 'package:workshop_shopping_app/services/user_service.dart';

class OrderService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    return user.uid;
  }

  CollectionReference get _ordersCollection => _firestore.collection('orders');

  double calculateTotal(List<Item> cartItems) {
    double subtotal = 0.0;
    for (var item in cartItems) {
      subtotal += item.price * item.quantity;
    }

    return double.parse(subtotal.toStringAsFixed(2));
  }

  Future<void> _updateProductInventory(List<Item> cartItems) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var item in cartItems) {
        DocumentReference productRef = _firestore
            .collection('products')
            .doc(item.productId);

        batch.update(productRef, {
          'sales': FieldValue.increment(item.quantity),
          'quantity': FieldValue.increment(-item.quantity),
        });

        await batch.commit();
      }
    } catch (e) {
      throw Exception('Error updating product inventory: $e');
    }
  }

  Future<String> createOrderFromCart(List<Item> cartItems) async {
    try {
      final user = await UserService().getUser();
      final address = user.address;
      final totalAmount = calculateTotal(cartItems);

      final order = AppOrder(
        userId: currentUserId,
        items: cartItems,
        totalAmount: totalAmount,
        shippingAddress: address,
        createdAt: DateTime.now(),
      );

      await _updateProductInventory(cartItems);

      DocumentReference doc = await _ordersCollection.add(order.toMap());

      debugPrint('Order created successfully');
      return doc.id;
    } catch (e) {
      debugPrint('Error creating order from cart: $e');
      throw Exception('Failed to create order from cart');
    }
  }

  Future<List<AppOrder>> getAllOrders() async {
    try {
      QuerySnapshot snapshot = await _ordersCollection
          .where('userId', isEqualTo: currentUserId)
          .get();
      List<AppOrder> orders = snapshot.docs.map((order) {
        return AppOrder.fromMap(
          order.data() as Map<String, dynamic>,
          docId: order.id,
        );
      }).toList();

      debugPrint('Retrieved ${orders.length} orders for user $currentUserId');
      return orders;
    } catch (e) {
      debugPrint('Error retrieving orders: $e');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Stack trace: ${StackTrace.current}');
      throw Exception('Failed to get orders');
    }
  }
}
