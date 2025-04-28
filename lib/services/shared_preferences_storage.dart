import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import './local_storage.dart';

class SharedPreferencesStorage implements LocalStorage {
  @override
  Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userData['email'], jsonEncode(userData));
  }

  @override
  Future<Map<String, dynamic>?> getUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(email);
    return userJson != null ? jsonDecode(userJson) as Map<String, dynamic> : null;
  }

  @override
  Future<void> updateUser(String email, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(email, jsonEncode(userData));
  }

  @override
  Future<void> deleteUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(email);
  }
}