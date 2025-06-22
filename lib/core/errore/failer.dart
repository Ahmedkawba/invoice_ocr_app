import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  /// خطأ عام من Supabase أو Auth
  factory ServerFailure.fromSupabaseError(Object error) {
    if (error is AuthException) {
      return ServerFailure(_mapSupabaseMessage(error.message));
    } else if (error is PostgrestException) {
      return ServerFailure(_mapSupabaseMessage(error.message));
    } else {
      return ServerFailure('حدث خطأ غير معروف من Supabase.');
    }
  }

  /// خطأ عام غير معروف، يشمل الشبكة وغيرها
  factory ServerFailure.fromGenericError(Object error) {
    if (error is SocketException) {
      return ServerFailure(
        '⚠️ لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.',
      );
    }

    final msg = error.toString().toLowerCase();
    if (msg.contains('failed host lookup')) {
      return ServerFailure(
        '⚠️ تعذر الوصول إلى الخادم. تحقق من اتصال الإنترنت.',
      );
    } else if (msg.contains('network') || msg.contains('timeout')) {
      return ServerFailure('⚠️ تعذر الاتصال بالخادم بسبب ضعف الشبكة.');
    }

    return ServerFailure('❌ حدث خطأ غير متوقع. الرجاء المحاولة لاحقًا.');
  }

  /// لإنشاء فشل من استجابة Supabase ذات statusCode
  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 404) {
      return ServerFailure('لم يتم العثور على الطلب. الرجاء المحاولة لاحقًا.');
    } else if (statusCode == 500) {
      return ServerFailure('مشكلة في الخادم. الرجاء المحاولة لاحقًا.');
    } else if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      final message = _extractMessage(response);
      return ServerFailure(message);
    } else {
      return ServerFailure('حدث خطأ غير متوقع. الرجاء المحاولة لاحقًا.');
    }
  }

  /// استخراج الرسالة من response المتغير
  static String _extractMessage(dynamic response) {
    if (response == null) {
      return 'استجابة غير صالحة من السيرفر.';
    }

    if (response is Map<String, dynamic>) {
      if (response.containsKey('message')) {
        return response['message'];
      } else if (response.containsKey('error')) {
        final error = response['error'];
        if (error is String) return error;
        if (error is List) return error.first.toString();
        if (error is Map && error.values.isNotEmpty) {
          final first = error.values.first;
          if (first is List) return first.first.toString();
          return first.toString();
        }
      }
    }

    return 'فشل غير معروف.';
  }

  /// ترجمة رسائل Supabase إلى رسائل واضحة للمستخدم
  static String _mapSupabaseMessage(String message) {
    message = message.toLowerCase();

    if (message.contains('invalid login credentials')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
    } else if (message.contains('email not confirmed')) {
      return 'لم يتم تأكيد البريد الإلكتروني بعد.';
    } else if (message.contains('network')) {
      return 'يرجى التحقق من اتصال الإنترنت.';
    } else if (message.contains('already registered') ||
        message.contains('user already exists')) {
      return 'هذا المستخدم مسجل بالفعل.';
    } else if (message.contains('password')) {
      return 'كلمة المرور غير صالحة أو ضعيفة.';
    } else if (message.contains('rate limit')) {
      return 'عدد كبير من المحاولات. الرجاء الانتظار.';
    }

    return message; // افتراضيًا نُظهر الرسالة كما هي
  }
}
