import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_theme.dart';
import 'core/config/theme_provider.dart';
import 'core/di/injection_container.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // 상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // 세로 모드 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // DI 초기화 (Clean Architecture)
  di.geminiDataSource.initialize();

  // 온보딩 완료 여부 확인
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding =
      prefs.getBool('hasCompletedOnboarding') ?? false;

  runApp(FaceFutureApp(showOnboarding: !hasCompletedOnboarding));
}

class FaceFutureApp extends StatelessWidget {
  final bool showOnboarding;

  const FaceFutureApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: '페이스 퓨처',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeDataMode,
            home: showOnboarding
                ? const OnboardingScreen()
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}
