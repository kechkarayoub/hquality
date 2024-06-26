import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n.dart';

class LanguagePickerDialog extends StatelessWidget {
  final L10n l10n;

  LanguagePickerDialog({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(l10n.translate("Select Language", Localizations.localeOf(context).languageCode)),
      children: [
        for (Locale locale in l10n.supportedLocales)
          SimpleDialogOption(
            onPressed: () {
              l10n.setLocale(locale);
              Navigator.pop(context); // Close the dialog
            },
            child: Text(l10n.translate("language_${locale.languageCode}", Localizations.localeOf(context).languageCode)),
          ),
      ],
    );
  }
}
