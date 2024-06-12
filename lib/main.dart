import 'package:flutter/material.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
      routes: {
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
      },
    );
  }
}
