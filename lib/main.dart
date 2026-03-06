import 'package:flutter/material.dart';
import 'Screens/splash_screen/OnboardScrens.dart';
import 'Screens/splash_screen/first_screnns.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScrenns(),
        '/Onboard': (context) => OnboardScrens(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
