import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/l10n/language_picker.dart';
import 'package:hquality/storage/storage.dart';
import 'package:hquality/utils/components.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'components_test.mocks.dart';

@GenerateNiceMocks([MockSpec<L10n>(), MockSpec<StorageService>()])

void main() {
  testWidgets('RenderDrawerMenu displays the correct items and handles logout', (WidgetTester tester) async {
    final l10n = MockL10n();
    final storageService = MockStorageService();

    when(l10n.translate("Menu", any)).thenReturn("Menu");
    when(l10n.translate("Logout", any)).thenReturn("Logout");

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Test App'),
          ),
          drawer: Builder(
            builder: (BuildContext context) {
              return renderDrawerMenu(l10n, storageService, context);
            },
          ),
        ),
      ),
    );

    // Ouvrir le tiroir en appuyant sur l'icône de menu
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Vérifiez que les éléments du tiroir sont affichés
    expect(find.text("Menu"), findsOneWidget);
    expect(find.text("Logout"), findsOneWidget);

    // Appuyez sur l'élément de déconnexion
    await tester.tap(find.text("Logout"));
    await tester.pumpAndSettle();

    // Vérifiez que la méthode clear du service de stockage est appelée
    verify(storageService.clear()).called(1);
  });

  testWidgets('RenderLanguagesIcon displays the language picker dialog', (WidgetTester tester) async {
    final l10n = MockL10n();
    final storageService = MockStorageService();

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Test App'),
              actions: [renderLanguagesIcon(l10n, storageService, context)], // Pass context here
            ),
          ),
        ),
      ),
    );

    // Find the IconButton
    final iconButtonFinder = find.byIcon(Icons.language);
    expect(iconButtonFinder, findsOneWidget);

    // Tap the IconButton to open the language picker dialog
    await tester.tap(iconButtonFinder);
    await tester.pumpAndSettle();

    // Verify that the language picker dialog is displayed
    expect(find.byType(LanguagePickerDialog), findsOneWidget);
  });

}