import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_theme.dart';
import '../../core/config/theme_provider.dart';

/// 설정 화면
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground(context),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, isDark),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildThemeSection(context, themeProvider, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              '⚙️ 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildThemeSection(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecorationFor(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                color: const Color(AppTheme.primaryColor),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '테마 설정',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildThemeOption(
            context,
            themeProvider,
            AppThemeMode.dark,
            '다크 모드',
            Icons.dark_mode,
            isDark,
          ),
          const SizedBox(height: 12),
          _buildThemeOption(
            context,
            themeProvider,
            AppThemeMode.light,
            '라이트 모드',
            Icons.light_mode,
            isDark,
          ),
          const SizedBox(height: 12),
          _buildThemeOption(
            context,
            themeProvider,
            AppThemeMode.system,
            '시스템 설정',
            Icons.settings_suggest,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    AppThemeMode mode,
    String label,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = themeProvider.themeMode == mode;

    return GestureDetector(
      onTap: () => themeProvider.setThemeMode(mode),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(AppTheme.primaryColor).withValues(alpha: 0.15)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(AppTheme.primaryColor)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(AppTheme.primaryColor)
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? const Color(AppTheme.primaryColor)
                      : (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(AppTheme.primaryColor),
              ),
          ],
        ),
      ),
    );
  }
}
