# RajaWash - Mobile Application

## Tentang Proyek
Aplikasi mobile RajaWash yang ditujukan untuk pelanggan dan operasional. Memungkinkan pengguna untuk memesan layanan laundry, melacak status pesanan, melakukan pembayaran (termasuk via QR Code), dan mengelola profil akun (termasuk gamifikasi level/poin).

## Teknologi Utama
- **Framework**: Flutter (SDK ^3.11.0)
- **State Management**: BLoC (`flutter_bloc`)
- **Routing**: GoRouter
- **Authentication**: Supabase Flutter & Google Sign-In
- **Network & API**: Dio
- **Local Storage**: Shared Preferences & Flutter Secure Storage
- **UI/UX**: Google Fonts, Gradient Borders, Animate Do, Qr Flutter

## Struktur Folder (Clean Architecture / Feature-First)
- `lib/core/`: Berisi kode-kode fundamental yang dapat digunakan ulang (konfigurasi tema, error handling, helper, interceptor Dio).
- `lib/features/`: Direktori fitur aplikasi yang dibagi per modul independen.
  - `auth/`: Modul login, registrasi, otentikasi Supabase.
  - `order/`: Modul pembuatan pesanan, riwayat, pelacakan.
  - `payment/`: Modul pembayaran pesanan, QR code (mis. `payment_qr_screen.dart`, `order_list_screen.dart`).
- Setiap fitur dalam `lib/features/` umumnya memiliki struktur sub-folder:
  - `data/`: Models, Repositories Implementation, Data Sources.
  - `domain/`: Entities, Repositories Interfaces.
  - `presentation/`: Pages/Screens, Widgets, dan BLoC (State Management).
- `lib/main.dart`: Titik masuk (entry point) aplikasi, injeksi dependensi, dan inisialisasi routing.

## Cara Menjalankan
1. Pastikan Flutter SDK (versi >= 3.11.0) sudah terinstal dan emulator/device terhubung.
2. Install dependencies: `flutter pub get`
3. Jalankan aplikasi: `flutter run`
