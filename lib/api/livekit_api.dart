import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/auth_service.dart';
import '../config/api_config.dart';

class LiveKitApi {
  final AuthService _authService = AuthService();

  // Get a LiveKit token from the server
  Future<String> getToken(String roomName, String identity) async {
    try {
      final authHeaders = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/livekit/token'),
        headers: {
          ...authHeaders,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'roomName': roomName,
          'identity': identity,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'];
      } else {
        throw Exception('Failed to get token: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error getting token: $e');
      // For testing only - create a token with LiveKit servers
      return await _getFallbackToken(roomName, identity);
    }
  }

  // Only for testing - get a fallback token from LiveKit demo servers
  Future<String> _getFallbackToken(String roomName, String identity) async {
    try {
      final livekitUrl = dotenv.env['LIVEKIT_URL'] ?? 'https://livekit.grayblock.io';
      final apiKey = dotenv.env['LIVEKIT_API_KEY'] ?? 'mykey1234';
      final apiSecret = dotenv.env['LIVEKIT_API_SECRET'] ?? 'mysecretshouldbelongerthan32wordssohereiamtypingsomeshitthatidontknowihope32wordsaredonenoworiwillhavetokeeptypingshouldistoplocal';

      final demoResponse = await http.post(
        Uri.parse('https://demos.livekit.io/api/token'),
        body: {
          'url': livekitUrl,
          'api_key': apiKey,
          'api_secret': apiSecret,
          'room': roomName,
          'username': identity,
        },
      );

      if (demoResponse.statusCode == 200) {
        return demoResponse.body;
      }

      throw Exception('Failed to get fallback token: ${demoResponse.statusCode}');
    } catch (e) {
      // Last resort hardcoded token (will only work for testing)
      debugPrint('Error getting fallback token: $e');
      throw Exception('Could not generate LiveKit token: Network error');
    }
  }
}