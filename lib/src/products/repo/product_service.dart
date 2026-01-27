import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_cart/core/status/failure.dart';
import 'package:easy_cart/core/status/success.dart';
import 'package:easy_cart/src/products/models/product.dart';

class ProductService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _productsCollection =>
      _firestore.collection('products');

  Future<Object> fetchAllProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection.get();
      List<Product> products = snapshot.docs.map((product) {
        return Product.fromMap(
          product.data() as Map<String, dynamic>,
          docId: product.id,
        );
      }).toList();
      return Success(response: products);
    } catch (e) {
      return Failure(response: 'Failed to fetch products');
    }
  }
}
