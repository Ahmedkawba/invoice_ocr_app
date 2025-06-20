import 'package:flutter/material.dart';

import 'widgets/custom_floatingaction_button.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  bool isLoading = false;

  void updateLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(child: Text("Invoices Screen")),
      floatingActionButton: CustomFloatingactionButton(
        onLoadingChanged: updateLoading,
      ),
    );
  }
}
