import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class ApiService {
  final AuthService _authService = AuthService();
  final String baseUrl = 'https://staging.grayblock.io/api';

  // Get auth headers for API requests
  Future<Map<String, String>> getAuthHeaders() async {
    return await _authService.getAuthHeaders();
  }

  // Generic GET request with authentication
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Generic POST request with authentication
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Generic PUT request with authentication
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success response
      return json.decode(response.body);
    } else {
      // Error response
      try {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? errorData['error'] ?? 'Request failed with status: ${response.statusCode}');
      } catch (e) {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    }
  }
}