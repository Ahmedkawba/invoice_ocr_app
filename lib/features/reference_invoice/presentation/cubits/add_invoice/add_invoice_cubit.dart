import 'package:bloc/bloc.dart';

import '../../../data/add_invoice_respones.dart';
import '../../../../../core/models/invoice_model.dart';

part 'add_invoice_state.dart';

class AddInvoiceCubit extends Cubit<AddInvoiceState> {
  AddInvoiceCubit() : super(AddInvoiceInitial());

  final AddProductRespones addProductRespones = AddProductResponesImpl();

  Future<void> addInvoice(InvoiceModel invoiceModel) async {
    emit(AddInvoiceLoading());
    final result = await addProductRespones.addProduct(
      invoiceModel: invoiceModel,
    );
    result.fold(
      (l) => emit(AddInvoiceError(l.message)),
      (r) => emit(AddInvoiceSuccess()),
    );
  }
}
