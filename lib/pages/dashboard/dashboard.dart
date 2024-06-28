import 'package:flutter/material.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/utils/utils.dart';
import 'package:hquality/l10n/language_picker.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';
  final L10n l10n;
  final dynamic userSession;

  DashboardPage({required this.l10n, required this.userSession});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.l10n.translate("Hello", Localizations.localeOf(context).languageCode) + " " + widget.userSession.lastName),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LanguagePickerDialog(l10n: widget.l10n);
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
