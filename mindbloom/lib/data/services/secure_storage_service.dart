import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const _onboardingKey = 'onboarding_status';
  static const _sessionTokenKey = 'session_token';

  Future<void> setOnboardingCompleted() async {
    await _storage.write(key: _onboardingKey, value: 'completed');
  }

  Future<bool> isOnboardingCompleted() async {
    final status = await _storage.read(key: _onboardingKey);
    return status == 'completed';
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _sessionTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _sessionTokenKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
