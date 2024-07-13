import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hquality/storage/storage.dart';
import 'package:hquality/utils/utils.dart';
import 'utils_test.mocks.dart';

// Génère le code pour Mockito
@GenerateNiceMocks([MockSpec<StorageService>()])

void main() {

  group('HexToColor', () {
    test('Converts hex string to Color object', () {
      final color = hexToColor('#FF5733');
      expect(color, equals(Color(0xFFFF5733)));
    });

    test('Converts hex string without hash to Color object', () {
      final color = hexToColor('FF5733');
      expect(color, equals(Color(0xFFFF5733)));
    });

    test('Handles invalid hex strings', () {
      expect(() => hexToColor('ZZZZZZ'), throwsFormatException);
    });
  });

  group('GetInitials', () {
    test('Returns initials from first and last name', () {
      final initials = getInitials('Doe', 'John');
      expect(initials, equals('DJ'));
    });

    test('Handles empty first name', () {
      final initials = getInitials('Doe', '');
      expect(initials, equals('D'));
    });

    test('Handles empty last name', () {
      final initials = getInitials('', 'John');
      expect(initials, equals('J'));
    });

    test('Handles both names empty', () {
      final initials = getInitials('', '');
      expect(initials, equals(''));
    });
  });

  group('GetRandomHexColor', () {
    test('Generates a valid hex color string', () {
      final hexColor = getRandomHexColor();
      final regex = RegExp(r'^#[0-9a-fA-F]{6}$');
      expect(regex.hasMatch(hexColor), isTrue);
    });

    test('Generates a color that is dark enough', () {
      for (int i = 0; i < 1000; i++) {
        final hexColor = getRandomHexColor();
        final color = hexToColor(hexColor);

        // Calculate brightness
        final brightness = (color.red * 299 + color.green * 587 + color.blue * 114) / 1000;
        expect(brightness, lessThanOrEqualTo(128));
      }
    });
  });


  testWidgets('Logout function clears all data from storage', (WidgetTester tester) async {
    // Crée les mocks pour StorageService
    final storageService = MockStorageService();

    // Configurer le mock pour vérifier que clear est appelé
    when(storageService.clear()).thenAnswer((_) async {});

    // Crée un widget de test
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () => logout(storageService, context),
                child: Text('Logout'),
              );
            },
          ),
        ),
      ),
    );

    // Simule un appui sur le bouton de déconnexion
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    // Vérifie que clear a bien été appelé
    verify(storageService.clear()).called(1);
  });
}
