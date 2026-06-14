/// Extension methods pada BuildContext untuk kemudahan akses.
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  /// Akses ThemeData.
  ThemeData get theme => Theme.of(this);

  /// Akses ColorScheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Akses TextTheme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Akses MediaQuery.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Ukuran layar.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Lebar layar.
  double get screenWidth => screenSize.width;

  /// Tinggi layar.
  double get screenHeight => screenSize.height;

  /// Tampilkan SnackBar.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Tampilkan bottom sheet.
  Future<T?> showBottomSheet<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }
}
