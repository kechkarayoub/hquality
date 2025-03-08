import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/components/gender_dropdown.dart';

import 'gender_dropdown_test.mocks.dart';

// Generate mocks
@GenerateMocks([L10n])
void main() {
  late MockL10n mockL10n;

  setUp(() {
    mockL10n = MockL10n();
  });

  group('GenderDropdown Tests', () {
    testWidgets('Displays gender options correctly', (WidgetTester tester) async {
      // Mock L10n translations
      when(mockL10n.translate("Gender", any)).thenReturn("Gender");
      when(mockL10n.translate("m_gender", any)).thenReturn("Male");
      when(mockL10n.translate("f_gender", any)).thenReturn("Female");
      when(mockL10n.translate("Please select your gender", any)).thenReturn("Please select your gender");

      // Build GenderDropdown widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return GenderDropdown(
                l10n: mockL10n,
                onChanged: (value) {},
              );
            },
          ),
        ),
      ));

      // Verify gender options are displayed correctly
      expect(find.text('Gender'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
    });

    testWidgets('Handles gender selection', (WidgetTester tester) async {
      String? selectedGender;

      // Mock L10n translations
      when(mockL10n.translate("Gender", any)).thenReturn("Gender");
      when(mockL10n.translate("m_gender", any)).thenReturn("Male");
      when(mockL10n.translate("f_gender", any)).thenReturn("Female");

      // Build GenderDropdown widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return GenderDropdown(
                l10n: mockL10n,
                onChanged: (value) {
                  selectedGender = value;
                },
              );
            },
          ),
        ),
      ));

      // Select gender
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Male').last);
      await tester.pumpAndSettle();

      // Verify gender selection is handled correctly
      expect(selectedGender, 'm');
    });

    testWidgets('Shows validation message for empty gender selection', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      // Mock L10n translations
      when(mockL10n.translate("Gender", any)).thenReturn("Gender");
      when(mockL10n.translate("m_gender", any)).thenReturn("Male");
      when(mockL10n.translate("f_gender", any)).thenReturn("Female");
      when(mockL10n.translate("Please select your gender", any)).thenReturn("Please select your gender");

      // Build GenderDropdown widget with Form
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: Builder(
              builder: (BuildContext context) {
                return GenderDropdown(
                  l10n: mockL10n,
                  onChanged: (value) {},
                );
              },
            ),
          ),
        ),
      ));

      // Submit the form without selecting a gender
      formKey.currentState!.validate();
      await tester.pump();

      // Verify validation message is displayed
      expect(find.text('Please select your gender'), findsOneWidget);
    });
  });
}
