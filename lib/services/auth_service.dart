import 'package:shared_preferences/shared_preferences.dart';

import './local_storage.dart';

class AuthService {
  final LocalStorage _storage;
  static const String _currentUserKey = 'current_user';

  const AuthService(this._storage);

  Future<bool> register(String email, String password, String name) async {
    final existingUser = await _storage.getUser(email);
    if (existingUser != null) return false; // User exists
    final userData = {'email': email, 'password': password, 'name': name};
    await _storage.saveUser(userData);
    return true;
  }

  Future<bool> login(String email, String password) async {
    final user = await _storage.getUser(email);
    if (user != null && user['password'] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, email);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    return await _storage.getUser(email);
  }

  Future<void> updateUser(String email, Map<String, dynamic> userData) async {
    await _storage.updateUser(email, userData);
  }

  Future<void> deleteUser(String email) async {
    await _storage.deleteUser(email);
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_currentUserKey) == email) {
      await prefs.remove(_currentUserKey);
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_currentUserKey);
  }
}
