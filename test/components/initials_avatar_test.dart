import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/components/initials_avatar.dart';
import 'package:hquality/utils/utils.dart';

void main() {
  group('InitialsAvatar Tests', () {
    testWidgets('Displays initials and background color correctly', (WidgetTester tester) async {
      // Define test data
      const String initials = 'AB';
      const String initialsBgColor = '#FF5733';

      // Build InitialsAvatar widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: InitialsAvatar(
              initials: initials,
              initialsBgColors: initialsBgColor,
            ),
          ),
        ),
      ));

      // Verify initials are displayed correctly
      expect(find.text(initials), findsOneWidget);

      // Verify background color is correct
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isInstanceOf<BoxDecoration>());
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.color, hexToColor(initialsBgColor));
    });

    testWidgets('Displays correct text style', (WidgetTester tester) async {
      // Define test data
      const String initials = 'XY';
      const String initialsBgColor = '#0000FF';

      // Build InitialsAvatar widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: InitialsAvatar(
              initials: initials,
              initialsBgColors: initialsBgColor,
            ),
          ),
        ),
      ));

      // Verify text style is correct
      final text = tester.widget<Text>(find.text(initials));
      expect(text.style?.color, Colors.white);
      expect(text.style?.fontSize, 40);
      expect(text.style?.fontWeight, FontWeight.bold);
    });
  });
}
