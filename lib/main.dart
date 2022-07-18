import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plastikat_client/Pages/HomePage.dart';
import 'Login.dart';
import 'globals.dart' as globals;

void main () async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String? logged = await globals.user.read(key: "login");
  if(logged=="true")
  {
    runApp(MaterialApp(home: HomePage(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: ((locale, supportedLocales) {
        if (supportedLocales.contains(locale)) return locale;
        if (locale?.languageCode == 'en') return const Locale('en', '');

        return supportedLocales.first;
      }),
    ));
  }
  else
  {
    runApp(MaterialApp(home: Login(false),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: ((locale, supportedLocales) {
        if (supportedLocales.contains(locale)) return locale;
        if (locale?.languageCode == 'en') return const Locale('en', '');

        return supportedLocales.first;
      }),
    ));
  }
}

