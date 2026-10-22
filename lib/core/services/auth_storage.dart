import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  static const String _businessProfileKey = 'business_profile';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _instance {
    return _prefs!;
  }

  /// Save JWT Token
  Future<void> saveToken(String token) async {
    await _instance.setString(_tokenKey, token);
  }

  /// Get Stored JWT Token
  String? getToken() {
    return _prefs?.getString(_tokenKey);
  }

  /// Save User JSON
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _instance.setString(_userKey, jsonEncode(userData));
  }

  /// Get Stored User Map
  Map<String, dynamic>? getUserData() {
    final jsonString = _prefs?.getString(_userKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  /// Save Business Profile
  Future<void> saveBusinessProfile(Map<String, dynamic> profile) async {
    await _instance.setString(_businessProfileKey, jsonEncode(profile));
  }

  /// Clear Stored Auth Credentials (Logout)
  Future<void> clearAuth() async {
    if (_prefs != null) {
      await _prefs!.remove(_tokenKey);
      await _prefs!.remove(_userKey);
      await _prefs!.remove(_businessProfileKey);
    }
  }
}
