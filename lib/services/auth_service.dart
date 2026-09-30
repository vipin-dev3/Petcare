import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static const String _authKey = 'petcare_logged_in';
  static const String _userNameKey = 'petcare_user_name';

  bool _isLoggedIn = false;
  String _userName = 'Admin';
  final String _role = 'Veterinary Director';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get role => _role;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_authKey) ?? false;
    _userName = prefs.getString(_userNameKey) ?? 'Admin';
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    // Allows admin:1234 or any valid credentials
    if ((username.trim().toLowerCase() == 'admin' && password == '1234') ||
        (username.trim().isNotEmpty && password.length >= 4)) {
      _isLoggedIn = true;
      _userName = username.trim();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_authKey, true);
      await prefs.setString(_userNameKey, _userName);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authKey, false);
    notifyListeners();
  }
}
