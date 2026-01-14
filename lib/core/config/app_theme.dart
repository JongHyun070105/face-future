import 'package:flutter/material.dart';

/// 앱 전역 테마 (Black Base + Light Mode)
class AppTheme {
  // Dark Theme Colors
  static const int darkBackgroundColor = 0xFF000000; // 완전 블랙
  static const int darkSurfaceColor = 0xFF17171C; // 어두운 회색 (카드 배경)
  static const int primaryColor = 0xFF3182F6; // 토스 블루 (포인트)
  static const int darkTextColor = 0xFFFFFFFF; // 메인 텍스트 (흰색)
  static const int darkSubTextColor = 0xFF8B95A1; // 서브 텍스트 (회색)
  static const int errorColor = 0xFFE54E5E; // 에러 레드

  // Light Theme Colors
  static const int lightBackgroundColor = 0xFFF5F6F8; // 밝은 그레이
  static const int lightSurfaceColor = 0xFFFFFFFF; // 흰색 카드
  static const int lightTextColor = 0xFF191F28; // 어두운 텍스트
  static const int lightSubTextColor = 0xFF6B7684; // 서브 텍스트

  // Legacy compatibility
  static const int backgroundColor = darkBackgroundColor;
  static const int surfaceColor = darkSurfaceColor;
  static const int secondaryColor = darkTextColor;
  static const int accentColor = darkSubTextColor;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(darkBackgroundColor),
      colorScheme: const ColorScheme.dark(
        primary: Color(primaryColor),
        secondary: Color(darkTextColor),
        tertiary: Color(darkSubTextColor),
        surface: Color(darkSurfaceColor),
        onSurface: Colors.white,
      ),
      fontFamily: 'Pretendard',
      cardTheme: CardThemeData(
        color: const Color(darkSurfaceColor),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(primaryColor),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(darkTextColor),
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(darkTextColor),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Color(darkTextColor), fontSize: 16),
        bodyMedium: TextStyle(color: Color(darkSubTextColor), fontSize: 14),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(lightBackgroundColor),
      colorScheme: const ColorScheme.light(
        primary: Color(primaryColor),
        secondary: Color(lightTextColor),
        tertiary: Color(lightSubTextColor),
        surface: Color(lightSurfaceColor),
        onSurface: Color(lightTextColor),
      ),
      fontFamily: 'Pretendard',
      cardTheme: CardThemeData(
        color: const Color(lightSurfaceColor),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(primaryColor),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(lightTextColor),
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(lightTextColor),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Color(lightTextColor), fontSize: 16),
        bodyMedium: TextStyle(color: Color(lightSubTextColor), fontSize: 14),
      ),
    );
  }

  // Gradient Background - 테마에 따라 다른 배경
  static BoxDecoration gradientBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark
          ? const Color(darkBackgroundColor)
          : const Color(lightBackgroundColor),
    );
  }

  // Legacy: Static gradient (dark mode)
  static BoxDecoration get gradientBackgroundStatic =>
      const BoxDecoration(color: Color(darkBackgroundColor));

  // Card Decoration - 테마에 따라 다른 스타일
  static BoxDecoration cardDecorationFor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark
          ? const Color(darkSurfaceColor)
          : const Color(lightSurfaceColor),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06),
        width: 1,
      ),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }

  // Legacy: Static card decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: const Color(darkSurfaceColor),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
  );

  // Neon Glow - Empty for clean style
  static List<BoxShadow> neonGlow(Color color) => [];

  // Glassmorphism
  static BoxDecoration glassmorphism({double opacity = 0.1}) {
    return BoxDecoration(
      color: const Color(darkSurfaceColor).withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
    );
  }
}
