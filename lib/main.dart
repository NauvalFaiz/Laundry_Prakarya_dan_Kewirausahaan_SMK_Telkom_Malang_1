import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prakarya_dan_kewirausahaan/Users/home.dart';
import 'Screens/authentication/login_screen.dart';
import 'Screens/splash_screen/OnboardScrens.dart';
import 'Screens/splash_screen/first_screnns.dart';

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
          '/login': (context) => LoginScreen(),
          '/home': (context) => Home(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  });
}
