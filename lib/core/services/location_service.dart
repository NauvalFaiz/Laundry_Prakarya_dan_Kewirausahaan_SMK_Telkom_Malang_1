import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Request location permission and get the current position.
  /// Throws an exception with a specific error message if permission is denied or GPS is disabled.
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah GPS (Location Services) aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('GPS tidak aktif. Mohon aktifkan GPS (Location Services) pada perangkat Anda.');
    }

    // 2. Cek status permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 3. Request permission jika denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin akses lokasi ditolak. Aplikasi tidak dapat mengambil lokasi Anda.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin akses lokasi ditolak secara permanen. Mohon izinkan akses lokasi melalui pengaturan aplikasi.');
    }

    // 4. Ambil lokasi saat ini
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
