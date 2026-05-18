import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service untuk menyimpan token & data sensitif secara aman
class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userNameKey = 'user_name';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';
  static const _userAvatarKey = 'user_avatar';
  static const _userRoleKey = 'user_role';

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  // ── Token Management ──
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  // ── User Info ──
  Future<void> saveUserInfo({
    String? name,
    int? id,
    String? email,
    String? avatar,
    String? role,
  }) async {
    if (name != null) await _storage.write(key: _userNameKey, value: name);
    if (id != null) await _storage.write(key: _userIdKey, value: id.toString());
    if (email != null) await _storage.write(key: _userEmailKey, value: email);
    if (avatar != null) await _storage.write(key: _userAvatarKey, value: avatar);
    if (role != null) await _storage.write(key: _userRoleKey, value: role);
  }

  Future<String?> getUserName() => _storage.read(key: _userNameKey);
  Future<String?> getUserEmail() => _storage.read(key: _userEmailKey);
  Future<String?> getUserAvatar() => _storage.read(key: _userAvatarKey);
  Future<String?> getUserRole() => _storage.read(key: _userRoleKey);

  Future<int?> getUserId() async {
    final id = await _storage.read(key: _userIdKey);
    return id != null ? int.tryParse(id) : null;
  }

  // ── Session Check ──
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ── Clear All ──
  Future<void> clearAll() => _storage.deleteAll();
}
