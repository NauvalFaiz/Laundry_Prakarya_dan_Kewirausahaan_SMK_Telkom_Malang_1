import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prakarya_dan_kewirausahaan/core/config/env_config.dart';
import 'package:prakarya_dan_kewirausahaan/core/utils/secure_storage.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String identifier, String password);
  Future<AuthModel> register(String name, String identifier, String password);
  Future<bool> loginWithGoogle();
  Future<AuthModel> syncGoogleUser(String supabaseAccessToken);
  Future<AuthModel> getProfile();
  Future<AuthModel> updateProfile(String name, String email);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final SecureStorageService storage;

  AuthRemoteDataSourceImpl({required this.dio, required this.storage});

  @override
  Future<AuthModel> login(String identifier, String password) async {
    try {
      final response = await dio.post('login', data: {
        'login': identifier,
        'password': password,
      });
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal login');
    }
  }

  @override
  Future<AuthModel> register(
      String name, String identifier, String password) async {
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

  /// Login Google Native (Tanpa Browser)
  @override
  Future<bool> loginWithGoogle() async {
    try {
      // 1. Inisialisasi Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: EnvConfig.googleWebClientId, // Penting untuk mendapatkan idToken yang valid bagi Supabase
      );

      // Paksa muncul pilihan akun (Sign out dulu baru sign in)
      await googleSignIn.signOut();

      // 2. Trigger Popup Akun Google
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false; // User cancel

      // 3. Dapatkan Token dari Google
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw Exception('Gagal mendapatkan ID Token dari Google');
      }

      // 4. Kirim ke Supabase menggunakan Native Method
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Jika berhasil, Supabase akan menyimpan session secara internal
      return response.session != null;
    } catch (e) {
      throw Exception('Native Google Login Error: ${e.toString()}');
    }
  }

  /// Kirim Supabase access token ke Laravel untuk exchange ke Sanctum token
  @override
  Future<AuthModel> syncGoogleUser(String supabaseAccessToken) async {
    try {
      final response = await dio.post('auth/google', data: {
        'access_token': supabaseAccessToken,
      });
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal sinkronisasi akun Google');
    }
  }

  /// Ambil profil user saat ini (untuk auto-login / session restore)
  @override
  Future<AuthModel> getProfile() async {
    try {
      final response = await dio.get('auth/me'); // Gunakan endpoint /auth/me yang baru dibuat
      
      final dynamic responseData = response.data;
      final Map<String, dynamic> userJson = (responseData is Map && responseData.containsKey('data'))
          ? responseData['data']
          : responseData;

      return AuthModel(
        user: UserModel.fromJson(userJson),
        token: await storage.getAccessToken(),
        success: true,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil profil');
    }
  }

  @override
  Future<AuthModel> updateProfile(String name, String email) async {
    try {
      final response = await dio.put('user', data: {
        'name': name,
        'email': email,
      });

      final dynamic responseData = response.data;
      final Map<String, dynamic> userJson = (responseData is Map && responseData.containsKey('data'))
          ? responseData['data']
          : responseData;

      return AuthModel(
        user: UserModel.fromJson(userJson),
        token: await storage.getAccessToken(),
        success: true,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memperbarui profil');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('logout');
    } catch (_) {}

    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}

    await storage.clearAll();
  }
}
