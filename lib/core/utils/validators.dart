/// Kumpulan fungsi validasi form yang digunakan di seluruh aplikasi.
///
/// Digunakan untuk validasi input pada halaman Login, Register,
/// Edit Profile, dan form lainnya.
import 'package:bookingku/core/constants/app_constants.dart';

class Validators {
  Validators._();

  /// Validasi email menggunakan regex standar.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi email atau nomor telepon (untuk login).
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email atau nomor telepon tidak boleh kosong';
    }
    // Check if it's a phone number (starts with 0 or +62)
    final phoneRegex = RegExp(r'^(\+62|0)[0-9]{9,13}$');
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!phoneRegex.hasMatch(value.trim()) && !emailRegex.hasMatch(value.trim())) {
      return 'Format email atau nomor telepon tidak valid';
    }
    return null;
  }

  /// Validasi password minimal 8 karakter.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Kata sandi minimal ${AppConstants.minPasswordLength} karakter';
    }
    return null;
  }

  /// Validasi konfirmasi password harus sama dengan password.
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi tidak boleh kosong';
    }
    if (value != password) {
      return 'Kata sandi tidak cocok';
    }
    return null;
  }

  /// Validasi nama tidak boleh kosong.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }

  /// Validasi nomor telepon Indonesia.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final phoneRegex = RegExp(r'^(\+62|0)[0-9]{9,13}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  /// Validasi field tidak boleh kosong.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }
}
