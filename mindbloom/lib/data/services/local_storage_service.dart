import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _themeKey = 'is_dark_mode';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;

  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(_themeKey, isDark);
  }

  Future<void> resetPreferences() async {
    await _prefs.clear();
  }
}
