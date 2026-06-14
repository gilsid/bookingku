/// Konstanta umum yang digunakan di seluruh aplikasi.
class AppConstants {
  AppConstants._();

  static const String appName = 'BookingKu';
  static const String appTagline = 'Reservasi Lapangan Mini Soccer';

  // Booking ID prefix
  static const String bookingIdPrefix = 'BKU-';

  // Image upload
  static const int maxImageSizeMB = 5;
  static const int maxImageSizeBytes = 5 * 1024 * 1024;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;
  static const int phoneMinLength = 10;
  static const int phoneMaxLength = 15;

  // Pagination
  static const int defaultPageSize = 10;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberLoginKey = 'remember_login';
  static const String isLoggedInKey = 'is_logged_in';
}
