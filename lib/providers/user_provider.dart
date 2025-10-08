import 'package:flutter/material.dart';
import 'package:nutrition/models/user.dart';
import 'package:nutrition/services/app_database.dart';
import 'package:nutrition/services/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isUserLoggedIn => _currentUser != null;

  // Load user data from database
  Future<void> loadUserData() async {
    final firebaseUser = AuthService().currentUser;
    if (firebaseUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await AppDatabase.instance.getUser(firebaseUser.uid);
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      await AppDatabase.instance.updateUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Clear user data (on logout)
  void clearUser() {
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  // Set user data (after onboarding)
  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }
}
