import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/api/backend.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'backend_test.mocks.dart';

// Génère le code pour Mockito
@GenerateMocks([http.Client])

void main() {

  setUpAll(() async {
    // Initialize dotenv before running tests
    await dotenv.load(fileName: ".env");
  });

  group('ApiBackendService', () {
    test('SignInUser returns user data if the http call completes successfully', () async {
      final client = MockClient();

      // Configure le client mock pour retourner une réponse 200 avec des données JSON
      when(client.post(
        Uri.parse('${dotenv.env['BACKEND_URL']}/user/login_with_token/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"success": true, "user": {"name": "John Doe"}}', 200));

      final data = {
        "email_or_username": "test@example.com",
        "selected_language": "en",
        "password": "password123",
      };

      final response = await ApiBackendService.signInUser(data: data, client: client);

      expect(response['success'], true);
      expect(response['user']['name'], 'John Doe');
    });

    test('SignInUser throws an exception if the http call completes with an error', () async {
      final client = MockClient();

      // Configure le client mock pour retourner une réponse 400 avec des données JSON
      when(client.post(
        Uri.parse('${dotenv.env['BACKEND_URL']}/user/login_with_token/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"error": "Invalid credentials"}', 400));

      final data = {
        "email_or_username": "test@example.com",
        "selected_language": "en",
        "password": "wrongpassword",
      };

      expect(ApiBackendService.signInUser(data: data, client: client), throwsException);
    });
  });
}
