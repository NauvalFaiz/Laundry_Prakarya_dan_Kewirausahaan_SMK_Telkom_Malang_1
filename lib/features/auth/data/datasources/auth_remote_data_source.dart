import 'package:dio/dio.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String identifier, String password);
  Future<AuthModel> register(String name, String identifier, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> login(String identifier, String password) async {
    try {
      final response = await dio.post('login', data: {
        'login': identifier, // Backend expects 'login'
        'password': password,
      });
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal login');
    }
  }

  @override
  Future<AuthModel> register(String name, String identifier, String password) async {
    try {
      // Determine if identifier is email or phone
      final isEmail = identifier.contains('@');
      final data = {
        'name': name,
        'password': password,
        'password_confirmation': password,
      };

      if (isEmail) {
        data['email'] = identifier;
      } else {
        data['phone'] = identifier;
      }

      final response = await dio.post('register', data: data);
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mendaftar');
    }
  }
}
