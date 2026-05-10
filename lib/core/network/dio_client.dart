import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.23:8000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    // Anda bisa menambahkan interceptor tambahan untuk token auth di sini
    // _dio.interceptors.add(InterceptorsWrapper(...));
  }

  Dio get dio => _dio;
}
