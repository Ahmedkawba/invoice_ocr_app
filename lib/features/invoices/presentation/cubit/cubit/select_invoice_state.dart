part of 'select_invoice_cubit.dart';

sealed class SelectInvoiceState extends Equatable {
  const SelectInvoiceState();

  @override
  List<Object> get props => [];
}

final class SelectInvoiceInitial extends SelectInvoiceState {}

final class SelectInvoiceLoading extends SelectInvoiceState {}

final class SelectInvoiceSuccess extends SelectInvoiceState {
  final List<InvoiceModel> invoice;
  const SelectInvoiceSuccess({required this.invoice});
}

final class SelectInvoiceFailure extends SelectInvoiceState {
  final String message;
  const SelectInvoiceFailure({required this.message});
}
