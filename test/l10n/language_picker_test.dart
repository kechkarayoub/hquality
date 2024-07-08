import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/l10n/language_picker.dart';
import 'package:hquality/storage/storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'language_picker_test.mocks.dart';

@GenerateMocks([L10n, StorageService]) // To generate mock classes

void main() {

  group('LanguagePickerDialog', () {

    late MockL10n mockL10n;
    late MockStorageService mockStorageService;

    setUp(() {
      mockL10n = MockL10n();
      mockStorageService = MockStorageService();
    });

    testWidgets('Displays supported languages and saves selection', (WidgetTester tester) async {
      // Arrange
      final supportedLocales = [
        Locale('en'),
        Locale('es'),
      ];
      
      when(mockL10n.supportedLocales).thenReturn(supportedLocales);
      when(mockL10n.translate(any, any)).thenAnswer((invocation) => invocation.positionalArguments[0]);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: LanguagePickerDialog(
                  l10n: mockL10n,
                  storageService: mockStorageService,
                ),
              );
            },
          ),
        ),
      );

      // Act
      // Simulate the display of the dialog
      await tester.tap(find.text('Select Language'));
      await tester.pumpAndSettle();

      // Assert
      for (Locale locale in supportedLocales) {
        expect(find.text('language_${locale.languageCode}'), findsOneWidget);
      }

      // Simulate selecting a language
      await tester.tap(find.text('language_en'));
      await tester.pumpAndSettle();

      verify(mockStorageService.set(
        key: 'current_language',
        obj: 'en',
        updateNotifier: true,
      )).called(1);
    });
  });
}