import 'package:dartz/dartz.dart';
import 'package:invoice_ocr_app/core/models/invoice_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errore/failer.dart';
import '../../../core/network/supabase_client.dart';

abstract class AddProductRespones {
  Future<Either<Failure, dynamic>> addInvoice({
    required InvoiceModel invoiceModel,
  });
}

// add invoice to supabase
class AddProductResponesImpl implements AddProductRespones {
  @override
  Future<Either<Failure, dynamic>> addInvoice({
    required InvoiceModel invoiceModel,
  }) async {
    try {
      var response = await AppSupabaseClient.client
          .from('invoices')
          .insert(invoiceModel.toJson());

      return right(response);
    } on AuthException catch (e) {
      final error = ServerFailure.fromSupabaseError(e);
      return left(error);
    } on PostgrestException catch (e) {
      final error = ServerFailure.fromSupabaseError(e);
      return left(error);
    } catch (e, stack) {
      print("❌ [saveToSupabase] Error: $e");
      print("📌 Stacktrace: $stack");

      final error = ServerFailure.fromGenericError(e);
      return left(error);
    }
  }
}
