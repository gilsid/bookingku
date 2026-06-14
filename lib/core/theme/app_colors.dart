/// Definisi semua warna yang digunakan dalam aplikasi BookingKu.
///
/// Semua warna terpusat di sini agar konsisten di seluruh aplikasi.
/// Warna diambil dari desain Figma BookingKu.
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryRed = Color(0xFFC41E3A);
  static const Color primaryDark = Color(0xFF1B1F3B);

  // Background
  static const Color backgroundLight = Color(0xFFF8F8F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF5F5F5);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);

  // Status
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color errorRed = Color(0xFFEF4444);

  // UI Elements
  static const Color disabledGrey = Color(0xFFD1D5DB);
  static const Color borderGrey = Color(0xFFE5E7EB);
  static const Color dividerGrey = Color(0xFFF3F4F6);
  static const Color unreadDot = Color(0xFFEF4444);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, Color(0xFF2D325A)],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B1F3B), Color(0xFF2D325A)],
  );
}
