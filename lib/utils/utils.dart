
import 'package:flutter/material.dart';
import 'package:hquality/storage/storage.dart';


final RegExp alphNumUnderscoreRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
const String defaultLanguage = "fr";
final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
final RegExp letterStartRegExp = RegExp(r'^[a-zA-Z]');
final RegExp nameRegExp = RegExp(r"^[a-zA-ZÀ-ÿ\s-]+$");
final RegExp usernameRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{2,19}$');

void logout(StorageService storageService, BuildContext context) {
  /// Logs out the user by clearing all data from the storage.
  /// This function clears all data from the storage, effectively logging the user out.
  /// [storageService] - The service used to manage storage operations.
  /// [context] - The build context used for navigation (if needed).
  storageService.clear();
  //Navigator.pushReplacementNamed(context, '/sign-in');
}
