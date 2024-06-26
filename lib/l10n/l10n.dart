import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hquality/utils/utils.dart';

class L10n {

  late Locale _locale;
  late Map<String, Map<String, String>> _translations;
  final ValueNotifier<Locale> _localeNotifier;

  L10n() : _localeNotifier = ValueNotifier(Locale(defaultLanguage)) {
    _locale = Locale(defaultLanguage); // Default locale
  }

  Locale get locale => _localeNotifier.value;

  List<Locale> get supportedLocales => [
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
  ];

  Future<void> loadTranslations() async {
    String data = await rootBundle.loadString('lib/l10n/translations.json');
    Map<String, dynamic> decodedData = json.decode(data);
    _translations = decodedData.map((key, value) {
      return MapEntry(key, Map<String, String>.from(value));
    });
  }

  String translate(String key, String locale) {
    if (_translations.containsKey(key)) {
      final Map<String, String> translationsForKey = _translations[key]!;
      if (translationsForKey.containsKey(locale)) {
        return translationsForKey[locale]!;
      }
      else{
        print("Needed translation for the key: $key");
      }
    }
    // If translation not found, return the key itself
    return key;
  }

  void setLocale(Locale newLocale) {
    _localeNotifier.value = newLocale;
  }

  ValueNotifier<Locale> get localeNotifier => _localeNotifier;
}
