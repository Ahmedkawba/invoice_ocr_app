import 'package:flutter/material.dart';
import 'package:invoice_ocr_app/core/app/routes.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initApp();
  }

  void initApp() async {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Routes.invoices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Icon(
                      Icons.inventory_outlined,
                      size: 100,
                      color: Color(0xFF00B2CA),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
