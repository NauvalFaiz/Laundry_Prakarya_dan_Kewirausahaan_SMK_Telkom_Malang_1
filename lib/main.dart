import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prakarya_dan_kewirausahaan/core/config/env_config.dart';
import 'package:prakarya_dan_kewirausahaan/core/di/injection.dart';
import 'package:prakarya_dan_kewirausahaan/core/router/app_router.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Supabase
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  // 2. Inisialisasi Dependency Injection (GetIt)
  await initDependencies();

  // 3. Lock Orientasi
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Ambil instance AuthBloc dari GetIt
        BlocProvider(create: (context) => sl<AuthBloc>()),
      ],
      child: MaterialApp.router(
        title: 'RajaWash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xff104E89),
        ),
        // Gunakan GoRouter
        routerConfig: AppRouter.router,
      ),
    );
  }
}
