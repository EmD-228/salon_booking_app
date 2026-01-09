import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper pour SharedPreferences avec une interface type-safe
class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  // String operations
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // Remove
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  // Reload
  Future<void> reload() async {
    await _prefs.reload();
  }
}

/// Clés de stockage local
class StorageKeys {
  StorageKeys._(); // Private constructor

  // Auth keys
  static const String userEmail = 'user_email';
  static const String userRegister = 'register';
  static const String userLogin = 'Login';
  static const String customerName = 'customer';
  
  // Owner keys
  static const String ownerId = 'id';
  static const String ownerEmail = 'email_owner';
  static const String ownerNumber = 'num';
  
  // App state
  static const String isFirstLaunch = 'is_first_launch';
  static const String userType = 'user_type'; // 'customer' or 'owner'
}

