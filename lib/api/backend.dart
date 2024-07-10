import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiBackendService {
  static String backendUrl = dotenv.env['BACKEND_URL'] ?? 'Backend URL not found';

  // Sign in a user with the provided data
  static Future<Map<String, dynamic>> signInUser({
    required dynamic data,
    http.Client? client,  // Client HTTP optionnel
  }) async {
    client ??= http.Client(); // Utiliser le client par défaut si aucun n'est fourni
    final url = Uri.parse('$backendUrl/user/login_with_token/');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response and return it
      return jsonDecode(response.body);
    } else {
      // Throw an exception if the response is not successful
      throw Exception('Failed to sign in: ${response.body}');
    }
  }
}
