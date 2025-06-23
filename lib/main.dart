import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:invoice_ocr_app/features/invoices/presentation/cubit/cubit/select_invoice_cubit.dart';

import 'core/app/routes.dart';
import 'core/network/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  AppSupabaseClient.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKay = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectInvoiceCubit(),
      child: MaterialApp(
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
      ),
    );
  }
}
