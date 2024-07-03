import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/l10n/l10n.dart';

void main() {
  test('Get supportedLocales', () async {
    final l10n = L10n();

    expect(l10n.supportedLocales.length, 3);
  });
  
  test('LoadTranslations and translate', () async {
    WidgetsFlutterBinding.ensureInitialized();
    final l10n = L10n();
    await l10n.loadTranslations();

    expect(l10n.translate("Hello", "en"), "Hello");
    expect(l10n.translate("Hello", "fr"), "Bonjour");
    expect(l10n.translate("Hello", "ar"), "مرحبا");
  });
}