import 'package:get_it/get_it.dart';
import 'package:prakarya_dan_kewirausahaan/core/network/dio_client.dart';
import 'package:prakarya_dan_kewirausahaan/core/utils/secure_storage.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/domain/repositories/auth_repository.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/domain/repositories/payment_repository.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/datasources/order_remote_data_source.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/repositories/order_repository_impl.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/domain/repositories/order_repository.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/bloc/order_bloc.dart';

final sl = GetIt.instance;

/// Inisialisasi semua dependency menggunakan GetIt
Future<void> initDependencies() async {
  // ── Core ──
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(storage: sl<SecureStorageService>()),
  );

  // ── Data Sources ──
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
      storage: sl<SecureStorageService>(),
    ),
  );

  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
    ),
  );

  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
    ),
  );

  // ── Repositories ──
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl<PaymentRemoteDataSource>()),
  );

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl<OrderRemoteDataSource>()),
  );

  // ── BLoCs (factory = instance baru setiap kali) ──
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: sl<AuthRepository>(),
      storage: sl<SecureStorageService>(),
    ),
  );

  sl.registerFactory<PaymentBloc>(
    () => PaymentBloc(
      paymentRepository: sl<PaymentRepository>(),
    ),
  );

  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      orderRepository: sl<OrderRepository>(),
    ),
  );
}
