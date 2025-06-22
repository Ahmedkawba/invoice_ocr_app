part of 'add_invoice_cubit.dart';

sealed class AddInvoiceState {}

final class AddInvoiceInitial extends AddInvoiceState {}

final class AddInvoiceLoading extends AddInvoiceState {}

final class AddInvoiceError extends AddInvoiceState {
  final String failure;
  AddInvoiceError(this.failure);
}

final class AddInvoiceSuccess extends AddInvoiceState {}
