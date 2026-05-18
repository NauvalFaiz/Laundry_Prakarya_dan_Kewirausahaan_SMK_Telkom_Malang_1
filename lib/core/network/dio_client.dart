import 'package:dio/dio.dart';
import 'package:prakarya_dan_kewirausahaan/core/config/env_config.dart';
import 'package:prakarya_dan_kewirausahaan/core/utils/secure_storage.dart';

class DioClient {
  final Dio _dio;
  final SecureStorageService _storage;

  DioClient({required SecureStorageService storage})
      : _storage = storage,
        _dio = Dio(
          BaseOptions(
            baseUrl: EnvConfig.apiBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.addAll([
      _AuthInterceptor(storage: _storage),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }

  Dio get dio => _dio;
}

/// Interceptor untuk menambahkan Bearer token otomatis
/// dan handle 401 Unauthorized
class _AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;

  _AuthInterceptor({required SecureStorageService storage})
      : _storage = storage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired / invalid — clear session
      await _storage.clearAll();
    }
    handler.next(err);
  }
}
