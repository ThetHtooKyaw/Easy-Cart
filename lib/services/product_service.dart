import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/models/product.dart';

class ProductService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _productsCollection =>
      _firestore.collection('products');

  Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection.get();
      List<Product> products = snapshot.docs.map((product) {
        debugPrint('Product data: ${product.data()}');
        return Product.fromMap(
          product.data() as Map<String, dynamic>,
          docId: product.id,
        );
      }).toList();
      return products;
    } catch (e) {
      debugPrint('Error retrieving products: $e');
      throw Exception('Failed to get products');
    }
  }
}
