import 'package:flutter/material.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/utils/utils.dart';
import 'package:hquality/l10n/language_picker.dart';
import 'package:hquality/storage/storage.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign-in';
  final L10n l10n;
  final StorageService storageService;

  SignInPage({required this.l10n, required this.storageService});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.l10n.translate("Sign In", Localizations.localeOf(context).languageCode)),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LanguagePickerDialog(l10n: widget.l10n, storageService: widget.storageService);
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: widget.l10n.translate("Email", Localizations.localeOf(context).languageCode)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.l10n.translate("Please enter your email", Localizations.localeOf(context).languageCode);
                  }
                  if (!emailRegExp.hasMatch(value)) {
                    return widget.l10n.translate("Please enter a valid email address", Localizations.localeOf(context).languageCode);
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: widget.l10n.translate("Password", Localizations.localeOf(context).languageCode)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.l10n.translate("Please enter your password", Localizations.localeOf(context).languageCode);
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform the sign-in logic
                    signInUser(widget.storageService);
                  }
                },
                child: Text(widget.l10n.translate("Sign in", Localizations.localeOf(context).languageCode)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpPage.routeName);
                },
                child: Text(widget.l10n.translate("Don't have an account? Sign up", Localizations.localeOf(context).languageCode)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signInUser(StorageService storageService) {
    // Add your sign-in logic here, such as an HTTP request to your backend.
    final email = _emailController.text;
    final password = _passwordController.text;
    var userSession = {"last_name": "last_name"};
    storageService.set(key: "user_session", obj: userSession, updateNotifier: true);
    print('Email: $email');
    print('Password: $password');

    // Here you would send the data to your backend server
  }
}
