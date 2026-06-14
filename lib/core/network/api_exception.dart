/// Custom exception untuk error dari API.
///
/// Digunakan oleh ApiClient saat terjadi error pada request.
/// Saat ini belum digunakan karena menggunakan mock data,
/// namun sudah disiapkan untuk integrasi backend.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';

  /// Factory untuk error umum.
  factory ApiException.unknown() => const ApiException(
    message: 'Terjadi kesalahan. Silakan coba lagi.',
  );

  factory ApiException.networkError() => const ApiException(
    message: 'Tidak ada koneksi internet.',
  );

  factory ApiException.timeout() => const ApiException(
    message: 'Koneksi timeout. Silakan coba lagi.',
  );

  factory ApiException.unauthorized() => const ApiException(
    message: 'Sesi Anda telah berakhir. Silakan login kembali.',
    statusCode: 401,
  );

  factory ApiException.serverError() => const ApiException(
    message: 'Terjadi kesalahan pada server.',
    statusCode: 500,
  );
}
