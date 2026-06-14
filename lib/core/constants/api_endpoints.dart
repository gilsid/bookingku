/// Daftar endpoint API yang akan digunakan saat backend tersedia.
///
/// Saat ini semua data menggunakan mock datasource.
/// Ketika backend siap, cukup ganti MockDatasource dengan RemoteDatasource
/// yang menggunakan endpoint-endpoint ini.
///
/// Arsitektur:
/// BookingKu Mobile → REST API → Database ← BookingKu Admin Web
class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL untuk API. Akan dikonfigurasi saat backend tersedia.
  static const String baseUrl = 'https://api.bookingku.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';

  // User Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String changePassword = '/profile/change-password';
  static const String uploadAvatar = '/profile/avatar';

  // Fields
  static const String fields = '/fields';
  static const String fieldDetail = '/fields/{id}';
  static const String fieldImages = '/fields/{id}/images';
  static const String popularFields = '/fields/popular';

  // Schedules
  static const String schedules = '/schedules';
  static const String schedulesByField = '/fields/{id}/schedules';
  static const String schedulesByDate = '/schedules?date={date}';

  // Bookings
  static const String bookings = '/bookings';
  static const String bookingDetail = '/bookings/{id}';
  static const String bookingHistory = '/bookings/history';
  static const String cancelBooking = '/bookings/{id}/cancel';

  // Payments
  static const String payments = '/payments';
  static const String paymentDetail = '/payments/{id}';
  static const String uploadProof = '/payments/{id}/proof';
  static const String paymentAccounts = '/payment-accounts';

  // Promos
  static const String promos = '/promos';
  static const String promoDetail = '/promos/{id}';
  static const String validatePromo = '/promos/validate';

  // Notifications
  static const String notifications = '/notifications';
  static const String markRead = '/notifications/{id}/read';
  static const String markAllRead = '/notifications/read-all';
}
