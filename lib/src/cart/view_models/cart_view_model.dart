import 'package:flutter/foundation.dart';
import 'package:easy_cart/src/cart/models/cart_item.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel();

  // Variables
  final List<CartItem> _cartItems = [];

  // Getters
  List<CartItem> get cartItems => _cartItems;

  // Use Cases
  void addToCart({required CartItem newItem}) {
    if (_cartItems.any((item) => item.productId == newItem.productId)) {
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item.productId == newItem.productId,
      );

      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = CartItem(
        productId: existingItem.productId,
        productName: existingItem.productName,
        imageUrl: existingItem.imageUrl,
        price: existingItem.price,
        quantity: existingItem.quantity + newItem.quantity,
      );
      notifyListeners();
    } else {
      _cartItems.add(newItem);
      notifyListeners();
    }
  }

  void removeFromCart({required int productIndex}) {
    _cartItems.removeAt(productIndex);
    notifyListeners();
  }

  void updateQuantity({required int productIndex, required int newQuantity}) {
    if (newQuantity <= 0) {
      removeFromCart(productIndex: productIndex);
      notifyListeners();
    }

    if (productIndex != -1) {
      final existingItem = _cartItems[productIndex];
      _cartItems[productIndex] = CartItem(
        productId: existingItem.productId,
        productName: existingItem.productName,
        imageUrl: existingItem.imageUrl,
        price: existingItem.price,
        quantity: newQuantity,
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
