import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'core/app/routes.dart';

void main() {
  runApp(const MyApp());
}
//AIzaSyBJFE4Rl8EeM_YF5hAt4ukxtCwVqQYLyyo
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKay = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      initialRoute: Routes.splash,
      navigatorKey: navigatorKay,
      onGenerateRoute: Routes.onGenerateRouted,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        // Locale('ar'), 
        Locale('en'),
      ],
    );
  }
}
