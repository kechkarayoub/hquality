import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hquality/l10n/l10n.dart';
import 'package:hquality/pages/dashboard/dashboard.dart';
import 'package:hquality/pages/sign_in_up/sign_in_page.dart';
import 'package:hquality/pages/sign_in_up/sign_up_page.dart';
import 'package:hquality/storage/storage.dart';
import 'package:hquality/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final l10n = L10n();
  await l10n.loadTranslations();
  StorageService storageService = StorageService();
  // var currentLanguage = await storageService.get("current_language");
  runApp(MyApp(l10n: l10n, /*currentLanguage: currentLanguage,*/ storageService: storageService,));
}

class MyApp extends StatelessWidget {
  final L10n l10n;
  // final String currentLanguage;
  final StorageService storageService;
  MyApp({required this.l10n/*, required this.currentLanguage*/, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<dynamic>(
      valueListenable: storageService.storageNotifier,
      builder: (context, storage, _) {
        print(storage);
        dynamic userSession = storage['user_session'];
        String currentLanguage = storage['current_language'] ?? defaultLanguage;
        return MaterialApp(
          builder: (context, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Auth App'),
              ),
              body: child,
            );
          },
          locale: Locale(currentLanguage), // Default language
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
          home: userSession != null ? DashboardPage(l10n: l10n, userSession: userSession, storageService: storageService) : SignInPage(l10n: l10n, storageService: storageService),
          routes: {
            DashboardPage.routeName: (context) => DashboardPage(l10n: l10n, userSession: userSession, storageService: storageService),
            SignInPage.routeName: (context) => SignInPage(l10n: l10n, storageService: storageService),
            SignUpPage.routeName: (context) => SignUpPage(l10n: l10n, storageService: storageService),
          },
        );
      },
    );
  }
}
