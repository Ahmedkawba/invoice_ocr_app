import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:invoice_ocr_app/core/app/routes.dart';

import '../../../../core/models/invoice_model.dart';
import '../cubits/add_invoice/add_invoice_cubit.dart';

class ReferenceInvoiceScreen extends StatefulWidget {
  final List<dynamic> deltaJson;
  final bool? isReadOnly;
  final String? title;

  const ReferenceInvoiceScreen({
    super.key,
    required this.deltaJson,
    this.isReadOnly = false,
    this.title,
  });

  @override
  State<ReferenceInvoiceScreen> createState() => _ReferenceInvoiceScreenState();
}

class _ReferenceInvoiceScreenState extends State<ReferenceInvoiceScreen> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    final delta = Delta.fromJson(widget.deltaJson);
    _controller = QuillController(
      readOnly: widget.isReadOnly ?? false,
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

    return BlocProvider(
      create: (context) => AddInvoiceCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AddInvoiceCubit, AddInvoiceState>(
            listener: (context, state) {
              if (state is AddInvoiceSuccess) {
                Navigator.pushNamed(
                  context,
                  Routes.resultInvoice,
                  arguments: {"isSuccess": true, "message": "تم الحفظ بنجاح!"},
                );
              } else if (state is AddInvoiceError) {
                Navigator.pushNamed(
                  context,
                  Routes.resultInvoice,
                  arguments: {"isSuccess": false, "message": state.failure},
                );
              }
            },
            builder: (context, state) {
              if (state is AddInvoiceLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    BlocListener<AddInvoiceCubit, AddInvoiceState>(
                      listener: (context, state) {
                        if (state is AddInvoiceSuccess) {
                          _isLoading = false;
                          setState(() {});
                          Navigator.pushNamed(
                            context,
                            Routes.resultInvoice,
                            arguments: {
                              "isSuccess": true,
                              "message": "تم الحفظ بنجاح!",
                            },
                          );
                        }
                        if (state is AddInvoiceError) {
                          _isLoading = false;
                          setState(() {});
                          Navigator.pushNamed(
                            context,
                            Routes.resultInvoice,
                            arguments: {
                              "isSuccess": false,
                              "message": state.failure,
                            },
                          );
                        }
                        if (state is AddInvoiceLoading) {
                          _isLoading = true;
                          setState(() {});
                        }
                      },
                      child: Container(),
                    ),

                    _buildAppBar(context),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Padding _buildTextForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        readOnly: widget.isReadOnly ?? false,
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

  Row _buildAppBar(BuildContext context) {
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
          onPressed: () {
            if (widget.isReadOnly ?? false) {
              Navigator.pop(context);
            } else {
              if (!_formKey.currentState!.validate()) return;

              final invoiceModel = InvoiceModel(
                title: _titleController.text,
                invoicetext: _controller.document.toPlainText(),
                richContent: _controller.document.toDelta().toJson(),
              );
              BlocProvider.of<AddInvoiceCubit>(
                context,
              ).addInvoice(invoiceModel);
            }
          },
          child: Text(
            widget.isReadOnly ?? false ? 'Close' : 'Done',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
