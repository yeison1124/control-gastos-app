import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyUserName = 'userName';
  static const String _keyUserId = 'userId';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    return _prefs!.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get user email
  Future<String?> getUserEmail() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserEmail);
  }

  // Get user name
  Future<String?> getUserName() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserName);
  }

  // Get user ID
  Future<String?> getUserId() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserId);
  }

  // Login user
  Future<void> login({
    required String email,
    required String name,
    String? userId,
  }) async {
    await _ensureInitialized();
    await _prefs!.setBool(_keyIsLoggedIn, true);
    await _prefs!.setString(_keyUserEmail, email);
    await _prefs!.setString(_keyUserName, name);
    if (userId != null) {
      await _prefs!.setString(_keyUserId, userId);
    }
  }

  // Logout user
  Future<void> logout() async {
    await _ensureInitialized();
    await _prefs!.setBool(_keyIsLoggedIn, false);
    await _prefs!.remove(_keyUserEmail);
    await _prefs!.remove(_keyUserName);
    await _prefs!.remove(_keyUserId);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  // Ensure SharedPreferences is initialized
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
