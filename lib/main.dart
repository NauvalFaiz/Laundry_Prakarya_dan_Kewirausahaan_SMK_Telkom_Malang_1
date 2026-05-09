import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prakarya_dan_kewirausahaan/features/home/presentation/pages/home.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/splash/presentation/pages/OnboardScrens.dart';
import 'features/splash/presentation/pages/first_screnns.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MaterialApp(
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
    );
  });
}
