import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _errorMessage;

  User? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }


  void _onAuthStateChanged(User? user) {
    _user = user;
    _errorMessage = null;  // Clear error message on successful sign-in
    notifyListeners();
  }


  Future<void> updateDisplayName(String displayName) async {
    if (_user != null) {
      await _user!.updateDisplayName(displayName);
      await _user!.reload();
      _user = _auth.currentUser;
      notifyListeners();
    }
  }
}