/// Implementasi Mock AuthRepository.
///
/// Menyimpan user login di SharedPreferences menggunakan StorageService.
import 'dart:convert';
import 'package:bookingku/core/services/storage_service.dart';
import 'package:bookingku/features/auth/data/models/user_model.dart';
import 'package:bookingku/features/auth/domain/entities/user.dart';
import 'package:bookingku/features/auth/domain/repositories/auth_repository.dart';
import 'package:bookingku/shared/models/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final StorageService _storageService;

  AuthRepositoryImpl(this._storageService);

  static const String _registeredUsersKey = 'registered_users';

  List<Map<String, dynamic>> _loadRegisteredUsers() {
    final data = _storageService.getString(_registeredUsersKey);
    if (data == null) return [];
    try {
      return (jsonDecode(data) as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveRegisteredUsers(List<Map<String, dynamic>> users) async {
    await _storageService.saveString(_registeredUsersKey, jsonEncode(users));
  }

  @override
  Future<Result<User>> login(String emailOrPhone, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Akun default untuk mock
    const mockEmail = 'ahmad.reza@email.com';
    const mockPhone = '081234567890';

    if ((emailOrPhone.trim() == mockEmail || emailOrPhone.trim() == mockPhone) &&
        password == '12345678') {
      const user = UserModel(
        id: 1,
        name: 'Ahmad Reza',
        email: mockEmail,
        phone: mockPhone,
        profileImageUrl: null,
      );

      await _storageService.saveToken('mock_jwt_token_ahmad_reza');
      await _storageService.saveUserData(jsonEncode(user.toJson()));
      await _storageService.setLoggedIn(true);

      return Result.success(user);
    }

    // Cek dari user yang sudah registrasi
    final registeredUsers = _loadRegisteredUsers();
    for (final data in registeredUsers) {
      if ((emailOrPhone.trim() == data['email'] || emailOrPhone.trim() == data['phone']) &&
          password == data['password']) {
        final user = UserModel.fromJson(data);

        await _storageService.saveToken('mock_jwt_token_${user.id}');
        await _storageService.saveUserData(jsonEncode(user.toJson()));
        await _storageService.setLoggedIn(true);

        return Result.success(user);
      }
    }

    return Result.failure('Email/Nomor telepon atau kata sandi salah');
  }

  @override
  Future<Result<User>> register(
      String name, String email, String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final registeredUsers = _loadRegisteredUsers();
    final newId = registeredUsers.length + 2;

    final newUser = UserModel(
      id: newId,
      name: name,
      email: email,
      phone: phone,
      profileImageUrl: null,
    );

    // Simpan ke daftar user terdaftar (tidak terhapus saat logout)
    registeredUsers.add({
      ...newUser.toJson(),
      'password': password,
    });
    await _saveRegisteredUsers(registeredUsers);

    // Simpan status login otomatis setelah register
    await _storageService.saveToken('mock_jwt_token_new_user');
    await _storageService.saveUserData(jsonEncode(newUser.toJson()));
    await _storageService.setLoggedIn(true);

    return Result.success(newUser);
  }

  @override
  Future<Result<void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Hanya hapus session, bukan data user terdaftar
    await _storageService.removeToken();
    await _storageService.setLoggedIn(false);
    return Result.success(null);
  }

  @override
  Future<Result<User>> getLoggedInUser() async {
    final userData = _storageService.getUserData();
    if (userData != null) {
      try {
        final user = UserModel.fromJson(jsonDecode(userData) as Map<String, dynamic>);
        return Result.success(user);
      } catch (e) {
        return Result.failure('Gagal memuat data pengguna');
      }
    }
    return Result.failure('Pengguna belum login');
  }

  @override
  Future<bool> checkLoginStatus() async {
    return _storageService.isLoggedIn();
  }

  @override
  Future<Result<User>> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? profileImageUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final currentUserResult = await getLoggedInUser();
    return currentUserResult.when(
      success: (user) async {
        final updatedUser = UserModel(
          id: user.id,
          name: name,
          email: email,
          phone: phone,
          profileImageUrl: profileImageUrl ?? user.profileImageUrl,
        );

        await _storageService.saveUserData(jsonEncode(updatedUser.toJson()));
        return Result.success(updatedUser);
      },
      failure: (msg) => Result.failure(msg),
    );
  }

  @override
  Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (oldPassword == '12345678') {
      return Result.success(null);
    } else {
      return Result.failure('Kata sandi lama salah');
    }
  }
}

