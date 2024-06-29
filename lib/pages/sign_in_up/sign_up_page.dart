import 'package:flutter/material.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/l10n/language_picker.dart';
import 'package:hquality/storage/storage.dart';
import 'package:hquality/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign-up';
  final L10n l10n;
  final StorageService storageService;

  SignUpPage({required this.l10n, required this.storageService});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.l10n.translate("Sign Up", Localizations.localeOf(context).languageCode)),
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
                controller: _lastNameController,
                decoration: InputDecoration(labelText: widget.l10n.translate("Last name", Localizations.localeOf(context).languageCode)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.l10n.translate("Please enter your last name", Localizations.localeOf(context).languageCode);
                  }
                  if (!nameRegExp.hasMatch(value)) {
                    return widget.l10n.translate("Last name can only contain alphabetic characters, hyphens, or apostrophes", Localizations.localeOf(context).languageCode);
                  }
                  return null;
                },
              ),
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
                    return widget.l10n.translate("Please enter your pawwaord", Localizations.localeOf(context).languageCode);
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform the sign-up logic
                    signUpUser();
                  }
                },
                child: Text(widget.l10n.translate("Sign up", Localizations.localeOf(context).languageCode)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUpUser() {
    // Add your sign-up logic here, such as an HTTP request to your backend.
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    print('Last name: $lastName');
    print('Email: $email');
    print('Password: $password');

    // Here you would send the data to your backend server
  }
}
