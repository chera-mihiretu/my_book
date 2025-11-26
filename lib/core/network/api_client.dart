import 'package:http/http.dart' as http;

/// API Client for making HTTP requests
class ApiClient {
  final http.Client client;
  final String baseUrl;
  final Duration timeout;

  ApiClient({
    required this.client,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
  });

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    // TODO: Implement GET request
    throw UnimplementedError();
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    // TODO: Implement POST request
    throw UnimplementedError();
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    // TODO: Implement PUT request
    throw UnimplementedError();
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    // TODO: Implement DELETE request
    throw UnimplementedError();
  }
}
