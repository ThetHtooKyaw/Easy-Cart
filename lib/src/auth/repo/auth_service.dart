import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_cart/core/status/failure.dart';
import 'package:easy_cart/core/status/success.dart';
import 'package:easy_cart/src/auth/models/app_user.dart';
import 'package:easy_cart/src/auth/view_models/params/login_params.dart';
import 'package:easy_cart/src/auth/view_models/params/signup_params.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Failure(response: 'No authenticated user found.');
    }
    return user.uid;
  }

  CollectionReference get _usersCollection => _firestore.collection('users');

  Future<Object?> createUser({required SignUpParams params}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      final user = AppUser(
        username: params.username,
        email: params.email,
        phoneNumber: params.phoneNumber,
        photoUrl: '',
        address: params.address,
        createdAt: DateTime.now(),
      );

      await _usersCollection.doc(currentUserId).set(user.toMap());

      return Success(response: 'User created successfully!');
    } on FirebaseAuthException catch (e) {
      return Failure(
        response: 'FirebaseAuthException: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return Failure(response: 'Failed to create user: $e.');
    }
  }

  Future<Object?> loginUser({required LoginParams params}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      return Success(response: 'User logged in successfully!');
    } on FirebaseAuthException catch (e) {
      return Failure(
        response: 'FirebaseAuthException: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return Failure(response: 'Failed to login user: $e.');
    }
  }

  Future<Object?> logoutUser() async {
    try {
      await _auth.signOut();
      return Success(response: 'User logged out successfully!');
    } on FirebaseAuthException catch (e) {
      return Failure(
        response: 'FirebaseAuthException: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return Failure(response: 'Failed to logout user: $e.');
    }
  }

  Future<Object> getUser() async {
    try {
      DocumentSnapshot snapshot = await _usersCollection
          .doc(currentUserId)
          .get();

      if (!snapshot.exists) {
        return Failure(response: 'User data not found.');
      }

      final user = AppUser.fromMap(snapshot.data() as Map<String, dynamic>);
      print('Fetched user data: ${user.toMap()}');

      return Success(response: user);
    } catch (e) {
      return Failure(response: 'Failed to fetch user data: $e.');
    }
  }
}
