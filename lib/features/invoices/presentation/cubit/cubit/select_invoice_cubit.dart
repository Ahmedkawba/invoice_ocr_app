import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:invoice_ocr_app/core/models/invoice_model.dart';
import 'package:invoice_ocr_app/features/invoices/data/select_invoice_respones.dart';

part 'select_invoice_state.dart';

class SelectInvoiceCubit extends Cubit<SelectInvoiceState> {
  SelectInvoiceCubit() : super(SelectInvoiceInitial());

  final SelectInvoiceRespones selectInvoiceRespones =
      SelectInvoiceResponesImpl();

  Future<void> selectInvoice() async {
    emit(SelectInvoiceLoading());
    final result = await selectInvoiceRespones.selectInvoice();
    result.fold(
      (failure) => emit(SelectInvoiceFailure(message: failure.message)),
      (invoice) => emit(SelectInvoiceSuccess(invoice: invoice)),
    );
  }
}
