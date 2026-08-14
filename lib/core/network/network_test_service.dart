import 'package:dio/dio.dart';

class NetworkTestService {
  final Dio _dio;

  NetworkTestService(this._dio);

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _dio.get('/auth/v1/user');

    return Map<String, dynamic>.from(response.data);
  }
}