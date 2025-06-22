import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/invoices/presentation/screen/invoices_screen.dart';
import '../../features/reference_invoice/presentation/screen/reference_invoice_screen.dart';
import '../../features/result/result_screen.dart';
import '../../features/splach_screen.dart';

class Routes {
  static const String splash = 'splash';
  static const String invoices = 'invoices';
  static const String referenceInvoice = 'referenceInvoice';
  static const String resultInvoice = 'resultInvoice';

  static String currentRoute = splash;

  static Route onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? "";
    switch (routeSettings.name) {
      case splash:
        return CupertinoPageRoute(builder: ((context) => const SplachScreen()));

      case invoices:
        return CupertinoPageRoute(builder: (_) => InvoicesScreen());
      case resultInvoice:
        final arg = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ResultScreen(
            isSuccess: arg?['isSuccess'],
            message: arg?['message'],
          ),
        );
      case referenceInvoice:
        final deltaJson = routeSettings.arguments as List<dynamic>;

        return CupertinoPageRoute(
          builder: (_) => ReferenceInvoiceScreen(deltaJson: deltaJson),
        );

      default:
        return CupertinoPageRoute(builder: (context) => const Scaffold());
    }
  }
}
