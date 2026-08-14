import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient({
    required String baseUrl,
    required String publishableKey,
    required SupabaseClient supabase,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'apikey': publishableKey,
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(supabase),
    );
  }
}