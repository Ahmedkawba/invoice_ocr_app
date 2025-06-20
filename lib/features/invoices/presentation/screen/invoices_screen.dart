import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice_ocr_app/core/app/routes.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  bool isLoading = false;
  File? imageFile;

  String scannedText = "";

  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(child: Text("Invoices Screen")),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        spacing: 10,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: Icon(Icons.image),
            label: 'اختر صورة',
            onTap: () => getImage(ImageSource.gallery),
          ),
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            label: 'التقاط',
            onTap: () => getImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
        isLoading = true;
        setState(() {});
        getRecognisedText(File(pickedImage.path));
      }
    } catch (e) {
      imageFile = null;
      isLoading = false;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(File image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer();
    RecognizedText recognisedText = await textRecognizer.processImage(
      inputImage,
    );
    String extractedText = recognisedText.text;

    final doc = Document()..insert(0, extractedText);

    isLoading = false;
    setState(() {});

    Navigator.pushNamed(
      context,
      Routes.referenceInvoice,
      arguments: doc.toDelta().toJson(),
    );
  }
}
