import 'package:flutter/material.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/l10n/language_picker.dart';
import 'package:hquality/storage/storage.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';
  final L10n l10n;
  final dynamic userSession;
  final StorageService storageService;

  DashboardPage({required this.l10n, required this.userSession, required this.storageService});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.l10n.translate("Hello", Localizations.localeOf(context).languageCode)} ${widget.userSession['last_name']}'),
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
        child: null,
      ),
    );
  }

}
