import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:tesseract_ocr/ocr_engine_config.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

import '../../../../../core/app/routes.dart';

class CustomFloatingactionButton extends StatefulWidget {
  const CustomFloatingactionButton({super.key, required this.onLoadingChanged});
  final Function(bool) onLoadingChanged; // دالة لتعديل الحالة في الوالد

  @override
  State<CustomFloatingactionButton> createState() =>
      _CustomFloatingactionButtonState();
}

class _CustomFloatingactionButtonState
    extends State<CustomFloatingactionButton> {
  File? imageFile;

  String scannedText = "";

  final ImagePicker picker = ImagePicker();
  @override
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
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
          onTap: () => _getImage(ImageSource.gallery),
        ),
        SpeedDialChild(
          child: Icon(Icons.camera_alt),
          label: 'التقاط',
          onTap: () => _getImage(ImageSource.camera),
        ),
      ],
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedImage = await picker.pickImage(source: source);
      if (pickedImage == null) return;

      setState(() {
        widget.onLoadingChanged(true); // تأكد من إعادة الحالة إلى false
        imageFile = File(pickedImage.path);
      });

      await _performOcr(imageFile!.path);
    } catch (e) {
      setState(() {
        widget.onLoadingChanged(false); // تأكد من إعادة الحالة إلى false
      });
      debugPrint('خطأ أثناء اختيار الصورة: $e');
    }
  }

  Future<void> _performOcr(String imagePath) async {
    try {
      await _copyTrainedDataIfNeeded();

      final tesseractConfig = OCRConfig(
        language: 'ara+eng',
        engine: OCREngine.tesseract,
        options: {
          TesseractConfig.preserveInterwordSpaces: '1',
          TesseractConfig.pageSegMode: PageSegmentationMode.auto,
        },
      );

      final extractedText = await TesseractOcr.extractText(
        imagePath,
        config: tesseractConfig,
      );

      final doc = Document()..insert(0, extractedText);

      widget.onLoadingChanged(false);

      Navigator.pushNamed(
        context,
        Routes.referenceInvoice,
        arguments: {'deltaJson': doc.toDelta().toJson(), 'isReadOnly': false},
      );
    } catch (e) {
      widget.onLoadingChanged(true);
      debugPrint('Error performing OCR: $e');
    }
  }

  Future<void> _copyTrainedDataIfNeeded() async {
    final appDir = await getApplicationDocumentsDirectory();
    final tessdataDir = Directory(path.join(appDir.path, 'tessdata'));

    if (!await tessdataDir.exists()) {
      await tessdataDir.create(recursive: true);
    }

    for (final lang in ['ara', 'eng']) {
      final file = File('${tessdataDir.path}/$lang.traineddata');
      if (!await file.exists()) {
        final byteData = await DefaultAssetBundle.of(
          context,
        ).load('assets/tessdata/$lang.traineddata');
        await file.writeAsBytes(byteData.buffer.asUint8List());
      }
    }
  }
}
