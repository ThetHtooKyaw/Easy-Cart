import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_cart/core/status/failure.dart';
import 'package:easy_cart/core/status/success.dart';
import 'package:easy_cart/src/auth/models/app_user.dart';
import 'package:easy_cart/src/cart/models/cart_item.dart';
import 'package:easy_cart/src/order/models/order.dart';

class OrderService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _ordersCollection => _firestore.collection('orders');

  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Failure(response: 'No authenticated user found.');
    }
    return user.uid;
  }

  Future<Object> loadOrders() async {
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
      return Success(response: orders);
    } catch (e) {
      return Failure(response: 'Failed to fetch orders: $e');
    }
  }

  Future<Object> checkOut({
    required List<CartItem> cartItems,
    required double totalAmount,
    required AppUser user,
  }) async {
    try {
      if (cartItems.isEmpty) {
        return Failure(response: 'Cart is empty. Cannot proceed to checkout.');
      }

      final order = AppOrder(
        userId: currentUserId,
        items: cartItems,
        totalAmount: totalAmount,
        shippingAddress: user.address,
        createdAt: DateTime.now(),
      );

      await _updateProductInventory(cartItems);

      DocumentReference doc = await _ordersCollection.add(order.toMap());

      return Success(response: doc.id);
    } catch (e) {
      return Failure(response: 'Failed to create order from cart: $e');
    }
  }

  Future<Object?> _updateProductInventory(List<CartItem> cartItems) async {
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
      }

      await batch.commit();

      return null;
    } catch (e) {
      return Failure(response: 'Error updating product inventory: $e');
    }
  }
}
