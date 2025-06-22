import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_ocr_app/features/invoices/presentation/cubit/cubit/select_invoice_cubit.dart';

import 'widgets/custom_floatingaction_button.dart';
import 'widgets/custom_invoices_item.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  bool isLoadingOCR = false;

  void updateLoading(bool value) {
    setState(() {
      isLoadingOCR = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SelectInvoiceCubit>(context).selectInvoice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("الفواتير"))),
      body: isLoadingOCR
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                context.read<SelectInvoiceCubit>().selectInvoice();
              },
              child: BlocBuilder<SelectInvoiceCubit, SelectInvoiceState>(
                builder: (context, state) {
                  if (state is SelectInvoiceSuccess) {
                    return state.invoice.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.invoice.length,
                            itemBuilder: (context, index) {
                              return CustomInvoicesItem(
                                invoice: state.invoice[index],
                              );
                            },
                          )
                        : Center(child: Text("No Invoices"));
                  } else if (state is SelectInvoiceFailure) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
      floatingActionButton: CustomFloatingactionButton(
        onLoadingChanged: updateLoading,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
