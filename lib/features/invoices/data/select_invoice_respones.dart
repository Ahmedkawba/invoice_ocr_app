import 'package:dartz/dartz.dart';
import 'package:invoice_ocr_app/core/models/invoice_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errore/failer.dart';
import '../../../core/network/supabase_client.dart';

abstract class SelectInvoiceRespones {
  Future<Either<Failure, List<InvoiceModel>>> selectInvoice();
}

class SelectInvoiceResponesImpl implements SelectInvoiceRespones {
  @override
  Future<Either<Failure, List<InvoiceModel>>> selectInvoice() async {
    try {
      var response = await AppSupabaseClient.client
          .from('invoices')
          .select()
          .order('created_at', ascending: false);

      final List<InvoiceModel> invoices = List<Map<String, dynamic>>.from(
        response,
      ).map((e) => InvoiceModel.fromJson(e)).toList();

      return right(invoices);
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
