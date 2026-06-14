/// Extension methods pada String.
extension StringExtensions on String {
  /// Capitalize huruf pertama.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize setiap kata.
  String get titleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Cek apakah string adalah email.
  bool get isEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Cek apakah string adalah nomor telepon.
  bool get isPhone {
    return RegExp(r'^(\+62|0)[0-9]{9,13}$').hasMatch(this);
  }
}
