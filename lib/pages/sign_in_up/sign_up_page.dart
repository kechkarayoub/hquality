import 'package:flutter/material.dart';
import 'package:hquality/api/backend.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/storage/storage.dart';
import 'package:hquality/utils/components.dart';
import 'package:hquality/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


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
  final DateFormat _dateFormat = DateFormat(dateFormat);
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatedController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String? _errorMessage;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: Localizations.localeOf(context), // Add localization
    );
    if (picked != null) {
      print("picked");
      print(picked);
      print(picked.toString());
      setState(() {
        _birthdayController.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.l10n.translate("Sign Up", Localizations.localeOf(context).languageCode)),
        actions: [
          renderLanguagesIcon(widget.l10n, widget.storageService, context),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show error message if present
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        widget.l10n.translate(_errorMessage!, Localizations.localeOf(context).languageCode),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: widget.l10n.translate("First name", Localizations.localeOf(context).languageCode)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return widget.l10n.translate("Please enter your first name", Localizations.localeOf(context).languageCode);
                      }
                      if (!nameRegExp.hasMatch(value)) {
                        return widget.l10n.translate("First name can only contain alphabetic characters, hyphens, or apostrophes", Localizations.localeOf(context).languageCode);
                      }
                      return null;
                    },
                  ),
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
                    controller: _birthdayController,
                    decoration: InputDecoration(
                      labelText: widget.l10n.translate("Birthday", Localizations.localeOf(context).languageCode),
                      hintText: dateFormatLabel,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your birthday';
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
                  // Email or username text field
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: widget.l10n.translate("Username", Localizations.localeOf(context).languageCode)),
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return widget.l10n.translate("Please enter your username", Localizations.localeOf(context).languageCode);
                      }
                      if(!letterStartRegExp.hasMatch(value)) {
                        return widget.l10n.translate("Username must start with a letter.", Localizations.localeOf(context).languageCode);
                      }
                      else if(!alphNumUnderscoreRegExp.hasMatch(value)) {
                        return widget.l10n.translate("Username can only contain letters, numbers, and underscores.", Localizations.localeOf(context).languageCode);
                      }
                      else if(value.length < 3 || value.length > 20) {
                        return widget.l10n.translate("Username must be between 3 and 20 characters long.", Localizations.localeOf(context).languageCode);
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
                      else if(value.length < 8) {
                        return widget.l10n.translate("Password length must be greater than or equal to 8", Localizations.localeOf(context).languageCode);
                      }
                      else if (_passwordRepeatedController.text.isNotEmpty && value != _passwordRepeatedController.text) {
                        return widget.l10n.translate("The two passwords do not match", Localizations.localeOf(context).languageCode);
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordRepeatedController,
                    decoration: InputDecoration(labelText: widget.l10n.translate("Re-enter your password", Localizations.localeOf(context).languageCode)),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return widget.l10n.translate("Please re-enter your pawwaord", Localizations.localeOf(context).languageCode);
                      }
                      else if(value.length < 8) {
                        return widget.l10n.translate("Password length must be greater than or equal to 8", Localizations.localeOf(context).languageCode);
                      }
                      else if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
                        return widget.l10n.translate("The two passwords do not match", Localizations.localeOf(context).languageCode);
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform the sign-up logic
                        signUpUser(widget.storageService, Localizations.localeOf(context).languageCode);
                      }
                    },
                    child: Text(widget.l10n.translate("Sign Up", Localizations.localeOf(context).languageCode)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUpUser(StorageService storageService, String currentLanguage, {http.Client? client}) async {
    // Add your sign-up logic here, such as an HTTP request to your backend.
    final birthday = _birthdayController.text;
    final firsName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;

    print("Selected birthday");
    print(birthday);

    client ??= http.Client(); // Use default client if none is provided

    final dynamic data = {
      "email": email,
      "first_name": firsName,
      "last_name": lastName,
      "selected_language": currentLanguage,
      "password": password,
      "username": username,
    };
    try {
      final response = await ApiBackendService.signInUser(data: data, client: client);

      // Assuming the response contains the user session data
      if(response["success"] && response["user"] != null){
        setState(() {
          _errorMessage = null;  // Clear the error message on successful sign-in
        });
        widget.storageService.set(key: 'user_session', obj: response["user"], updateNotifier: true);
      }
      else if(!response["success"] && response["message"] != null){
        setState(() {
          _errorMessage = response["message"];  // Set the error message on unsuccessful sign-in
        });
        print('Sign-in error: ${response["message"]}');
      }
      else{
        setState(() {
          _errorMessage = "An error occurred when log in!";  // Set the error message on unsuccessful sign-in
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred when log in!";  // Set the error message on unsuccessful sign-in
      });
      // Handle any errors that occurred during the HTTP request
      print('Sign-in error: $e');
    }
    // Here you would send the data to your backend server
  }



  @override
  void dispose() {
    _birthdayController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _passwordRepeatedController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
