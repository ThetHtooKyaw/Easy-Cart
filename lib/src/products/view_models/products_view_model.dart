import 'package:flutter/material.dart';
import 'package:easy_cart/core/status/failure.dart';
import 'package:easy_cart/core/status/success.dart';
import 'package:easy_cart/src/products/models/product_error.dart';
import 'package:easy_cart/src/products/repo/product_service.dart';
import 'package:easy_cart/src/products/models/product.dart';

class ProductsViewModel extends ChangeNotifier {
  // Dependencies
  final ProductService _productService;
  ProductsViewModel(this._productService);

  // Variables
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _loading = false;
  ProductError? _productError;

  // Getters
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get loading => _loading;
  ProductError? get productError => _productError;

  // Setters
  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setProductError(ProductError productError) {
    _productError = productError;
    notifyListeners();
  }

  void clearProductError() {
    _productError = null;
    notifyListeners();
  }

  // Use Cases
  Future<void> loadProducts() async {
    setLoading(true);
    clearProductError();

    final response = await _productService.fetchAllProducts();

    if (response is Success) {
      _products = response.response as List<Product>;
      _filteredProducts = _products;
    } else if (response is Failure) {
      setProductError(ProductError(message: response.response.toString()));
    }

    setLoading(false);
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
