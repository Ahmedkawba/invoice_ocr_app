import 'package:bloc/bloc.dart';

import '../../../../../core/models/invoice_model.dart';
import '../../../data/add_invoice_respones.dart';

part 'add_invoice_state.dart';

class AddInvoiceCubit extends Cubit<AddInvoiceState> {
  AddInvoiceCubit() : super(AddInvoiceInitial());

  final AddProductRespones addProductRespones = AddProductResponesImpl();

  Future<void> addInvoice(InvoiceModel invoiceModel) async {
    emit(AddInvoiceLoading());
    final result = await addProductRespones.addInvoice(
      invoiceModel: invoiceModel,
    );
    result.fold(
      (l) => emit(AddInvoiceError(l.message)),
      (r) => emit(AddInvoiceSuccess()),
    );
  }
}
