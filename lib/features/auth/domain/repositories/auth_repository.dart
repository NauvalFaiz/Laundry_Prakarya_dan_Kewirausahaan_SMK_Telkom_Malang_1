import 'package:prakarya_dan_kewirausahaan/features/auth/data/models/auth_model.dart';

abstract class AuthRepository {
  Future<AuthModel> login(String identifier, String password);
  Future<AuthModel> register(String name, String identifier, String password);
  Future<bool> loginWithGoogle();
  Future<AuthModel> syncGoogleUser(String supabaseAccessToken);
  Future<AuthModel> getProfile();
  Future<void> logout();
}
