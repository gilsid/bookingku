/// AuthProvider untuk manajemen state autentikasi pada presentasi layer.
import 'package:flutter/material.dart';
import 'package:bookingku/features/auth/domain/entities/user.dart';
import 'package:bookingku/features/auth/domain/repositories/auth_repository.dart';
import 'package:bookingku/shared/models/result.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authRepository);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Cek apakah pengguna sudah memiliki sesi login aktif.
  Future<bool> checkLoginStatus() async {
    final isLoggedIn = await _authRepository.checkLoginStatus();
    if (isLoggedIn) {
      final result = await _authRepository.getLoggedInUser();
      result.when(
        success: (user) {
          _currentUser = user;
          notifyListeners();
        },
        failure: (msg) {
          _currentUser = null;
          notifyListeners();
        },
      );
      return _currentUser != null;
    }
    return false;
  }

  /// Melakukan login.
  Future<Result<User>> login(String emailOrPhone, String password) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _authRepository.login(emailOrPhone, password);

    result.when(
      success: (user) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Melakukan pendaftaran akun baru.
  Future<Result<User>> register(
      String name, String email, String phone, String password) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _authRepository.register(name, email, phone, password);

    result.when(
      success: (user) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Melakukan logout.
  Future<Result<void>> logout() async {
    _setLoading(true);
    final result = await _authRepository.logout();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
    return result;
  }

  /// Update data user lokal secara langsung (misal setelah edit profile)
  void updateCurrentUser(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  /// Memperbarui profil pengguna.
  Future<Result<User>> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? profileImageUrl,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _authRepository.updateProfile(
      name: name,
      email: email,
      phone: phone,
      profileImageUrl: profileImageUrl,
    );

    result.when(
      success: (user) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Mengubah kata sandi.
  Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _authRepository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    _isLoading = false;
    notifyListeners();
    return result;
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}

