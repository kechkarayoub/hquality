import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/api/backend.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/pages/sign_in_up/sign_in_page.dart';
import 'package:hquality/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_page_test.mocks.dart';

// Generate mocks
@GenerateMocks([L10n, StorageService, http.Client])
void main() {
  late MockL10n mockL10n;
  late MockStorageService mockStorageService;
  late MockClient mockClient;

  setUp(() async {
    await dotenv.load(fileName: ".env");
    mockL10n = MockL10n();
    mockStorageService = MockStorageService();
    mockClient = MockClient();
  });

  testWidgets('SignInPage UI elements test', (WidgetTester tester) async {
    
      
    // Mock L10n translations
    when(mockL10n.translate(any, any)).thenAnswer((invocation) => invocation.positionalArguments[0] as String);
    // Build SignInPage widget
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(l10n: mockL10n, storageService: mockStorageService),
    ));

    // Verify the presence of key widgets and elements
    expect(find.text('Sign In'), findsOneWidget); // App bar title
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email/Username and Password fields
    expect(find.text('Sign in'), findsOneWidget); // Sign in button
    expect(find.text("Don't have an account? Sign up"), findsOneWidget); // Sign up button
  });

  testWidgets('Sign-in process with successful response', (WidgetTester tester) async {
    // Mock successful sign-in response
    when(mockClient.post(
      Uri.parse('${ApiBackendService.backendUrl}/user/login_with_token/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"success": true, "user": {"username": "testuser", "email": "test@example.com"}}', 200));

    // Mock L10n translations
    when(mockL10n.translate(any, any)).thenAnswer((invocation) => invocation.positionalArguments[0] as String);

    // Build SignInPage widget
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(l10n: mockL10n, storageService: mockStorageService),
    ));

    // Enter email and password
    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Sign in'));

    // Add client parameter in the button press callback
    final signInButton = find.byType(ElevatedButton);
    await tester.tap(signInButton);
    final signInState = tester.state<SignInPageState>(find.byType(SignInPage));
    signInState.signInUser(mockStorageService, 'en', client: mockClient);

    await tester.pumpAndSettle();

    // Verify that the error message is null after successful sign-in
    expect(find.text('An error occurred when logging in!'), findsNothing);

    // Verify that the client.post was called once
    verify(mockClient.post(
      Uri.parse('${ApiBackendService.backendUrl}/user/login_with_token/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: anyNamed('body'),
    )).called(1);

    // Verify that storageService.set was called once with expected parameters
    verify(mockStorageService.set(key: 'user_session', obj: anyNamed('obj'), updateNotifier: true)).called(1);
  });

  testWidgets('Sign-in process with unsuccessful response', (WidgetTester tester) async {
    // Mock unsuccessful sign-in response
    when(mockClient.post(
      Uri.parse('${ApiBackendService.backendUrl}/user/login_with_token/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"success": false, "message": "Invalid credentials"}', 200));

    // Mock L10n translations
    when(mockL10n.translate(any, any)).thenAnswer((invocation) => invocation.positionalArguments[0] as String);

    // Build SignInPage widget
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(l10n: mockL10n, storageService: mockStorageService),
    ));

    // Enter email and password
    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
    await tester.tap(find.text('Sign in'));

    // Add client parameter in the button press callback
    final signInButton = find.byType(ElevatedButton);
    await tester.tap(signInButton);
    final signInState = tester.state<SignInPageState>(find.byType(SignInPage));
    signInState.signInUser(mockStorageService, 'en', client: mockClient);
    await tester.pumpAndSettle();

    // Verify that the error message is displayed
    expect(find.text('Invalid credentials'), findsOneWidget);

    // Verify that the client.post was called once
    verify(mockClient.post(
      Uri.parse('${ApiBackendService.backendUrl}/user/login_with_token/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: anyNamed('body'),
    )).called(1);
  });
  testWidgets('Shows error message for invalid email address', (WidgetTester tester) async {
    // Mock L10n translations
    when(mockL10n.translate(any, any)).thenAnswer((invocation) => invocation.positionalArguments[0] as String);

    // Build SignInPage widget
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(l10n: mockL10n, storageService: mockStorageService),
    ));

    // Enter an invalid email address
    await tester.enterText(find.byType(TextFormField).at(0), 'invalid@email');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    // Verify the correct error message is displayed
    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('Shows error message for empty email address', (WidgetTester tester) async {
    // Mock L10n translations
    when(mockL10n.translate(any, any)).thenAnswer((invocation) => invocation.positionalArguments[0] as String);

    // Build SignInPage widget
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(l10n: mockL10n, storageService: mockStorageService),
    ));

    // Leave the email address field empty
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    // Verify the correct error message is displayed
    expect(find.text('Please enter your email or username'), findsOneWidget);
  });

  testWidgets('Shows error message for empty password', (WidgetTester tester) async {
    // Mock L10n translations
    when(mockL10n.translate(any, any)).thenAnswer((invocation) => invocation.positionalArguments[0] as String);

    // Build SignInPage widget
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(l10n: mockL10n, storageService: mockStorageService),
    ));

    // Leave the email address field empty
    await tester.enterText(find.byType(TextFormField).at(0), 'testusername');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    // Verify the correct error message is displayed
    expect(find.text("Please enter your password"), findsOneWidget);
  });

}