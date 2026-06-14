/// HTTP client yang disiapkan untuk komunikasi dengan REST API.
///
/// Saat ini belum digunakan karena menggunakan mock data.
/// Ketika backend tersedia, client ini akan digunakan oleh
/// RemoteDatasource untuk mengirim request ke server.
///
/// Arsitektur integrasi:
/// RemoteDatasource → ApiClient → REST API → Database
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookingku/core/constants/api_endpoints.dart';
import 'package:bookingku/core/network/api_exception.dart';
import 'package:bookingku/core/network/api_response.dart';

class ApiClient {
  final http.Client _client;
  String? _authToken;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Set auth token setelah login.
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Hapus auth token saat logout.
  void clearAuthToken() {
    _authToken = null;
  }

  /// Headers default untuk setiap request.
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  /// GET request.
  Future<ApiResponse<dynamic>> get(String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint')
          .replace(queryParameters: queryParams);
      final response = await _client.get(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException.networkError();
    }
  }

  /// POST request.
  Future<ApiResponse<dynamic>> post(String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final response = await _client.post(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException.networkError();
    }
  }

  /// PUT request.
  Future<ApiResponse<dynamic>> put(String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final response = await _client.put(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException.networkError();
    }
  }

  /// DELETE request.
  Future<ApiResponse<dynamic>> delete(String endpoint) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final response = await _client.delete(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException.networkError();
    }
  }

  /// Handle response dari server.
  ApiResponse<dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.success(body);
    } else if (response.statusCode == 401) {
      throw ApiException.unauthorized();
    } else if (response.statusCode >= 500) {
      throw ApiException.serverError();
    } else {
      throw ApiException(
        message: body['message'] ?? 'Terjadi kesalahan.',
        statusCode: response.statusCode,
        data: body,
      );
    }
  }

  /// Dispose client.
  void dispose() {
    _client.close();
  }
}
