import 'package:flutter/foundation.dart';
import 'package:easy_cart/src/cart/models/cart_item.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel();

  // Variables
  List<CartItem> cartItems = [];

  void addToCart({required CartItem newItem}) {
    if (cartItems.any((item) => item.productId == newItem.productId)) {
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.productId == newItem.productId,
      );

      final existingItem = cartItems[existingItemIndex];
      cartItems[existingItemIndex] = CartItem(
        productId: existingItem.productId,
        productName: existingItem.productName,
        imageUrl: existingItem.imageUrl,
        price: existingItem.price,
        quantity: existingItem.quantity + newItem.quantity,
      );
      notifyListeners();
    } else {
      cartItems.add(newItem);
      notifyListeners();
    }
  }

  void removeFromCart({required int productIndex}) {
    cartItems.removeAt(productIndex);
    notifyListeners();
  }

  void updateQuantity({required int productIndex, required int newQuantity}) {
    if (newQuantity <= 0) {
      removeFromCart(productIndex: productIndex);
      notifyListeners();
    }

    if (productIndex != -1) {
      final existingItem = cartItems[productIndex];
      cartItems[productIndex] = CartItem(
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
    cartItems.clear();
    notifyListeners();
  }
}
