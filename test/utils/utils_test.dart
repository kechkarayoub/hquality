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
