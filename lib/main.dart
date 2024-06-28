import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';
import 'package:hquality/utils/utils.dart';
import 'l10n/language_picker.dart';
import 'pages/sign_in_up/sign_in_page.dart';
import 'pages/sign_in_up/sign_up_page.dart';
import 'pages/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final l10n = L10n();
  await l10n.loadTranslations();
  final  dynamic userSession = null;
  var currentLanguage = defaultLanguage;
  runApp(MyApp(l10n: l10n, userSession: userSession, currentLanguage: currentLanguage));
}

class MyApp extends StatelessWidget {
  final L10n l10n;
  final dynamic userSession;
  final String currentLanguage;
  MyApp({required this.l10n, required this.userSession, required this.currentLanguage});

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
          home: userSession != null ? DashboardPage(l10n: l10n, userSession: userSession) : SignInPage(l10n: l10n),
          routes: {
            DashboardPage.routeName: (context) => DashboardPage(l10n: l10n, userSession: userSession),
            SignInPage.routeName: (context) => SignInPage(l10n: l10n),
            SignUpPage.routeName: (context) => SignUpPage(l10n: l10n),
          },
        );
      },
    );
  }
}
