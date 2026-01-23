import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/models/app_user.dart';

class UserService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    return user.uid;
  }

  CollectionReference get _usersCollection => _firestore.collection('users');

  Future<void> createUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = AppUser(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        photoUrl: '',
        address: address,
        createdAt: DateTime.now(),
      );

      await _usersCollection.doc(currentUserId).set(user.toMap());
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      throw Exception('FirebaseAuthException: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('Exception: $e');
      throw Exception(e);
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      throw Exception('FirebaseAuthException: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('Exception: $e');
      throw Exception(e);
    }
  }

  Future<AppUser> getUser() async {
    try {
      DocumentSnapshot snapshot = await _usersCollection
          .doc(currentUserId)
          .get();

      if (!snapshot.exists) {
        throw Exception('User data not found.');
      }

      return AppUser.fromMap(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      throw Exception('Failed to fetch user data.');
    }
  }
}
