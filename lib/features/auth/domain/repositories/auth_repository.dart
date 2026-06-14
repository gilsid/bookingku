/// Interface repository untuk autentikasi.
import 'package:bookingku/features/auth/domain/entities/user.dart';
import 'package:bookingku/shared/models/result.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String emailOrPhone, String password);
  Future<Result<User>> register(String name, String email, String phone, String password);
  Future<Result<void>> logout();
  Future<Result<User>> getLoggedInUser();
  Future<bool> checkLoginStatus();
  Future<Result<User>> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? profileImageUrl,
  });
  Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

