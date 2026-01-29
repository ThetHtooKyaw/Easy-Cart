import 'package:easy_cart/src/favourite/models/favourite_item.dart';
import 'package:easy_cart/src/products/models/product.dart';
import 'package:flutter/material.dart';

class FavouriteViewModel extends ChangeNotifier {
  FavouriteViewModel();

  // Variables
  final List<FavouriteItem> _favItems = [];

  // Getters
  List<FavouriteItem> get favItems => _favItems;

  // Use Cases
  bool isFavourite({required String productId}) {
    return _favItems.any((item) => item.productId == productId);
  }

  void toggleFavourite({required Product product}) {
    final id = product.id;
    if (id == null) return;

    final index = _favItems.indexWhere((item) => item.productId == id);

    if (index >= 0) {
      _favItems.removeAt(index);
    } else {
      _favItems.add(
        FavouriteItem(
          productId: id,
          productName: product.name,
          imageUrl: product.images.first,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeFavouriteById({required String productId}) {
    _favItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }
}
