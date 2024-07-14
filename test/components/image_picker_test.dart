import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/components/image_picker.dart';

void main() {
  testWidgets('ImagePickerWidget displays and removes image correctly', (WidgetTester tester) async {

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImagePickerWidget(
            initials: 'AB',
            initialsBgColor: '#FF5733',
            labelText: 'Pick Image',
            labelTextCamera: '',
            onImageSelected: (image) {
            },
          ),
        ),
      ),
    );

    // Verify initials avatar is displayed initially
    expect(find.text('AB'), findsOneWidget);

    // Simulate picking an image by setting the state manually
    final imagePickerWidgetState = tester.state<ImagePickerWidgetState>(find.byType(ImagePickerWidget));
    imagePickerWidgetState.setSelectedImageForTest(File('path/to/image.png'));


    // Rebuild the widget
    await tester.pump();

    // Verify the image is displayed
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.cancel), findsOneWidget);
    // Verify initials avatar is displayed again
    expect(find.text('AB'), findsNothing);

    // Remove the image
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pump();

    // Verify initials avatar is displayed again
    expect(find.text('AB'), findsOneWidget);
  });
}
