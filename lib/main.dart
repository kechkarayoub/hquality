import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';
import 'package:hquality/utils/utils.dart';
import 'l10n/language_picker.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final l10n = L10n();
  await l10n.loadTranslations();
  runApp(MyApp(l10n: l10n));
}

class MyApp extends StatelessWidget {
  final L10n l10n;
  MyApp({required this.l10n});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: l10n.localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          builder: (context, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Auth App'),
              ),
              body: child,
            );
          },
          locale: locale, // Default language
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: l10n.supportedLocales,
          title: 'Auth App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SignInPage(l10n: l10n),
          routes: {
            SignInPage.routeName: (context) => SignInPage(l10n: l10n),
            SignUpPage.routeName: (context) => SignUpPage(l10n: l10n),
          },
        );
      },
    );
  }
}
