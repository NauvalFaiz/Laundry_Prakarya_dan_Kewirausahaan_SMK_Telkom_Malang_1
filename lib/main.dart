import 'package:flutter/material.dart';
import 'package:prakarya_dan_kewirausahaan/Screens/Splace/OnboardScrens.dart';
import 'package:prakarya_dan_kewirausahaan/Screens/Splace/first_screnns.dart';

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
