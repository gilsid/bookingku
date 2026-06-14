/// Service untuk menyimpan data ke penyimpanan lokal.
///
/// Menggunakan SharedPreferences untuk menyimpan data sederhana
/// seperti token, status login, dan preferensi user.
///
/// Nantinya saat backend tersedia, token dari API akan disimpan
/// menggunakan service ini.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookingku/core/constants/app_constants.dart';

class StorageService {
  SharedPreferences? _prefs;

  /// Inisialisasi SharedPreferences.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth Token
  Future<void> saveToken(String token) async {
    await _prefs?.setString(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return _prefs?.getString(AppConstants.tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs?.remove(AppConstants.tokenKey);
  }

  // Login State
  Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(AppConstants.isLoggedInKey, value);
  }

  bool isLoggedIn() {
    return _prefs?.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  // Remember Login
  Future<void> setRememberLogin(bool value) async {
    await _prefs?.setBool(AppConstants.rememberLoginKey, value);
  }

  bool getRememberLogin() {
    return _prefs?.getBool(AppConstants.rememberLoginKey) ?? false;
  }

  // User Data
  Future<void> saveUserData(String jsonString) async {
    await _prefs?.setString(AppConstants.userKey, jsonString);
  }

  String? getUserData() {
    return _prefs?.getString(AppConstants.userKey);
  }

  // Generic methods
  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Hapus semua data (untuk logout).
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
