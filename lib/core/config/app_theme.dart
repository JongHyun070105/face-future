import 'package:flutter/material.dart';

/// 앱 전역 테마 (Black Base)
class AppTheme {
  // Black Style Colors
  static const int backgroundColor = 0xFF000000; // 완전 블랙
  static const int surfaceColor = 0xFF17171C; // 어두운 회색 (카드 배경)
  static const int primaryColor = 0xFF3182F6; // 토스 블루 (포인트)
  static const int secondaryColor = 0xFFFFFFFF; // 메인 텍스트 (흰색)
  static const int accentColor = 0xFF8B95A1; // 서브 텍스트 (회색)
  static const int errorColor = 0xFFE54E5E; // 에러 레드

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(backgroundColor),
      colorScheme: const ColorScheme.dark(
        primary: Color(primaryColor),
        secondary: Color(secondaryColor),
        tertiary: Color(accentColor),
        surface: Color(surfaceColor),
        onSurface: Colors.white,
      ),
      fontFamily: 'Pretendard',

      // Card Theme
      cardTheme: CardThemeData(
        color: const Color(surfaceColor),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),

      // Button Theme
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

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(secondaryColor),
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(secondaryColor),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Color(secondaryColor), fontSize: 16),
        bodyMedium: TextStyle(color: Color(accentColor), fontSize: 14),
      ),
    );
  }

  // Compatibility: Gradient Background (Now just Black for Black Base)
  static BoxDecoration get gradientBackground =>
      const BoxDecoration(color: Color(backgroundColor));

  // Card Decoration (Black Base style)
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: const Color(surfaceColor),
    borderRadius: BorderRadius.circular(24),
    // Dark mode requires subtle borders or lighter shadows for depth
    border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
  );

  // Neon Glow - Empty for clean style
  static List<BoxShadow> neonGlow(Color color) => [];

  // Glassmorphism - Adapted for Black Base
  static BoxDecoration glassmorphism({double opacity = 0.1}) {
    return BoxDecoration(
      color: const Color(surfaceColor).withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
    );
  }
}
