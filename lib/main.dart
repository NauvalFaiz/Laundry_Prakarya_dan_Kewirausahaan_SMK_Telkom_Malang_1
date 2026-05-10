import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prakarya_dan_kewirausahaan/features/home/presentation/pages/home.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/splash/presentation/pages/OnboardScrens.dart';
import 'features/splash/presentation/pages/first_screnns.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/core/network/dio_client.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final dioClient = DioClient();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio: dioClient.dio);
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authRepository: authRepository),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => FirstScrenns(),
            '/Onboard': (context) => OnboardScrens(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => Home(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  });
}
