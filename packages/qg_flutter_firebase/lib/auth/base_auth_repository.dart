import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// RequestResponse with AuthError namespace
abstract class BaseAuthRepository {
  Stream<User?> authStateChanges();
  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
  Future<void> signOut();
  Future<void> deleteUser();
  Future<User?> verifyPhoneNumber({
    required String phoneNumber,
    VoidCallback? verificationCompleted,
    VoidCallback? verificationFailed,
    VoidCallback? codeSent,
    VoidCallback? codeAutoRetrievalTimeout,
  });
}
