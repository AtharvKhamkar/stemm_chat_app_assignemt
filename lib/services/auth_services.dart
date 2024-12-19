import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();

  static AuthService get instance => _instance;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? user;

  Future<bool> registerUser(String email, String password) async {
    try {
      final credentials = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credentials.user != null) {
        user = credentials.user;
      }
      return true;
    } catch (e) {
      debugPrint('Error while registering user');
    }
    return false;
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      final credentials = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credentials.user != null) {
        user = credentials.user;
      }
      return true;
    } catch (e) {
      debugPrint('Error while logging user');
    }
    return false;
  }

  Future<bool> logoutUser() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint('Error while logging out user');
    }

    return false;
  }
}
