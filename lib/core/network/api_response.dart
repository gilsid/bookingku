/// Wrapper untuk response dari API.
///
/// Standarisasi response agar konsisten di seluruh aplikasi.
/// Disiapkan agar kompatibel dengan format response dari backend.
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message}) => ApiResponse(
    success: true,
    data: data,
    message: message,
  );

  factory ApiResponse.error(String message, {int? statusCode}) => ApiResponse(
    success: false,
    message: message,
    statusCode: statusCode,
  );
}
