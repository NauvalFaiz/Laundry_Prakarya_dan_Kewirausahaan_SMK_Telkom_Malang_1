import 'package:flutter/foundation.dart';

/// Konfigurasi environment aplikasi
class EnvConfig {
  // Supabase
  static const String supabaseUrl = 'https://cczginntppvutoonvcwu.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_UtWa9djLmcaQBA1MkWZE4Q_C34r-RIK';

  // Google Client ID (Required for Native Google Sign In with Supabase)
  // Use the WEB Client ID from Google Cloud Console
  static const String googleWebClientId = '147816297252-nv94nlcppihflrigneru9lc9ri94ohhg.apps.googleusercontent.com'; // Contoh / Placeholder jika belum ada

  // Laravel API
  static const String apiBaseUrl = 'http://192.168.100.164:8000/api/mobile/';

  // Deep Link (OAuth Callback)
  static const String callbackScheme = 'io.supabase.rajawash';
  
  static String get callbackUrl {
    if (kIsWeb) {
      // Untuk Web, gunakan origin dari browser (misal http://localhost:5000)
      return 'http://localhost:5000/'; 
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      // Untuk Windows Desktop
      return 'http://localhost:65432/';
    } else {
      // Untuk Mobile (Android/iOS)
      return '$callbackScheme://login-callback/';
    }
  }
}
