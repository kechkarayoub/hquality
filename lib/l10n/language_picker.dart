import 'l10n.dart';
import 'package:flutter/material.dart';
import 'package:hquality/storage/storage.dart';

class LanguagePickerDialog extends StatelessWidget {

  final L10n l10n;
  final StorageService storageService;

  LanguagePickerDialog({required this.l10n, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(l10n.translate("Select Language", Localizations.localeOf(context).languageCode)),
      children: [
        for (Locale locale in l10n.supportedLocales)
          SimpleDialogOption(
            onPressed: () {
              storageService.set("current_language", locale.toString());
              Navigator.pop(context); // Close the dialog
            },
            child: Text(l10n.translate("language_${locale.languageCode}", Localizations.localeOf(context).languageCode)),
          ),
      ],
    );
  }
}
