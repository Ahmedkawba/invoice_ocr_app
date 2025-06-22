import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app/routes.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, this.isSuccess, this.message});
  final bool? isSuccess;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.invoices,
              (route) => false,
            );
          }
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 40),
                if (isSuccess!)
                  Lottie.asset(
                    'assets/animations/success.json', // احفظ ملف JSON للرسوم المتحركة
                    width: 150,
                    height: 150,
                  ),
                if (!isSuccess!)
                  Lottie.asset(
                    'assets/animations/error.json',
                    width: 150,
                    height: 150,
                  ),
                const SizedBox(height: 60),

                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    isSuccess!
                        ? 'تم الحفظ بنجاح!'
                        : '$message حدث خطأ أثناء الحفظ!',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSuccess! ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess! ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (isSuccess!) {
                      Navigator.pushReplacementNamed(context, Routes.invoices);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    isSuccess! ? 'حسناً' : 'حاول مرة أخرى',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
