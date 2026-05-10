import 'package:prakarya_dan_kewirausahaan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/models/auth_model.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthModel> login(String identifier, String password) async {
    return await remoteDataSource.login(identifier, password);
  }

  @override
  Future<AuthModel> register(String name, String identifier, String password) async {
    return await remoteDataSource.register(name, identifier, password);
  }
}
