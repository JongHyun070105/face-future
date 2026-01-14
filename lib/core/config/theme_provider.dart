import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 테마 모드 열거형
enum AppThemeMode { dark, light, system }

/// 테마 관리 Provider
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  AppThemeMode _themeMode = AppThemeMode.dark;

  AppThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// 저장된 테마 불러오기
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey) ?? 'dark';
    _themeMode = AppThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => AppThemeMode.dark,
    );
    notifyListeners();
  }

  /// 테마 변경
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  /// 다크 모드 여부 확인
  bool isDarkMode(BuildContext context) {
    switch (_themeMode) {
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.light:
        return false;
      case AppThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  /// 현재 ThemeMode 반환
  ThemeMode get themeDataMode {
    switch (_themeMode) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
