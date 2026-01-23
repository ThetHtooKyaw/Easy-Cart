// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:workshop_shopping_app/data/product_data.dart';

// class ProductMigrationService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> migrateProducts() async {
//     try {
//       final batch = _firestore.batch();

//       for (var product in products) {
//         final docRef = _firestore.collection('products').doc(product.id);

//         batch.set(docRef, product.toMap());
//       }

//       await batch.commit();
//       print('Successfully migrated ${products.length} products to Firestore');
//     } catch (e) {
//       print('Error migrating products: $e');
//       rethrow;
//     }
//   }
// }
