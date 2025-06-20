import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class ReferenceInvoiceScreen extends StatefulWidget {
  final List<dynamic> deltaJson;

  const ReferenceInvoiceScreen({super.key, required this.deltaJson});

  @override
  State<ReferenceInvoiceScreen> createState() => _ReferenceInvoiceScreenState();
}

class _ReferenceInvoiceScreenState extends State<ReferenceInvoiceScreen> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final delta = Delta.fromJson(widget.deltaJson);
    _controller = QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  QuillSimpleToolbarConfig buildToolbarConfig({
    bool showUndo = false,
    bool showRedo = false,
    bool showFormatting = false,
    Color? color,
    bool showColorButton = false,
    bool showBackgroundColorButton = false,
    bool showListNumbers = false,
    bool showListBullets = false,
    bool showSearchButton = false,
    bool showFontSize = false,
  }) {
    return QuillSimpleToolbarConfig(
      color: color,
      multiRowsDisplay: false,
      showDividers: false,
      showFontFamily: false,
      showFontSize: showFontSize,
      showSmallButton: false,
      showInlineCode: false,
      showUndo: showUndo,
      showRedo: showRedo,
      showBoldButton: showFormatting,
      showItalicButton: showFormatting,
      showUnderLineButton: false,
      showStrikeThrough: false,
      showCodeBlock: false,
      showQuote: false,
      showListCheck: false,
      showIndent: false,
      showLink: false,
      showClearFormat: false,
      showHeaderStyle: false,
      showLineHeightButton: false,
      showSubscript: false,
      showSuperscript: false,
      showColorButton: showColorButton,
      showBackgroundColorButton: showBackgroundColorButton,
      showAlignmentButtons: showFormatting,
      showJustifyAlignment: showFormatting,
      showListNumbers: showListNumbers,
      showListBullets: showListBullets,
      showSearchButton: showSearchButton,
      toolbarSize: 20,
      buttonOptions: QuillSimpleToolbarButtonOptions(
        base: QuillToolbarBaseButtonOptions(iconTheme: QuillIconTheme()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Column(
                  children: [
                    _buildTextForm(),
                    Divider(
                      color: Colors.grey[300],
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: QuillSimpleToolbar(
                        controller: _controller,
                        config: buildToolbarConfig(
                          showFontSize: true,
                          showColorButton: true,
                          showBackgroundColorButton: true,
                          showListNumbers: true,
                          showListBullets: true,
                          showSearchButton: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        child: QuillEditor.basic(
                          controller: _controller,
                          config: const QuillEditorConfig(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isKeyboardVisible)
                Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  color: Colors.grey[100],
                  child: QuillSimpleToolbar(
                    controller: _controller,
                    config: buildToolbarConfig(
                      showFormatting: true,
                      color: Colors.grey[100],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTextForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          hintText: 'Title',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
        ),
        onChanged: (value) {
          _titleController.text = value;
          setState(() {});
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a title';
          }
          return null;
        },
      ),
    );
  }

  Row _buildAppBar() {
    return Row(
      children: [
        Expanded(
          child: QuillSimpleToolbar(
            controller: _controller,
            config: buildToolbarConfig(showUndo: true, showRedo: true),
          ),
        ),
        Spacer(),

        TextButton(
          onPressed: _saveDocument,
          child: Text(
            'Done',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _saveDocument() async {
    if (!_formKey.currentState!.validate()) return;
    final content = jsonEncode(_controller.document.toDelta().toJson());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
