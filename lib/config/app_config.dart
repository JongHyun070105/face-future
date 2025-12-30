import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 앱 전역 설정
class AppConfig {
  // Gemini API 키 (로컬 테스트용 - 나중에 환경변수로 이동)
  // TODO: 실제 API 키로 교체 필요!
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Gemini 모델명
  static const String geminiModel = 'gemini-2.5-flash-lite';

  // 앱 정보
  static const String appName = '페이스 퓨처';
  static const String appSubtitle = 'AI가 데이터로 분석한 나의 미래 직업과 연봉';

  // 컬러 HEX 코드
  static const int primaryColor = 0xFF6B21A8; // 딥 퍼플
  static const int secondaryColor = 0xFFEC4899; // 네온 핑크
  static const int accentColor = 0xFF06B6D4; // 시안
  static const int backgroundColor = 0xFF1F1F1F; // 다크 그레이
  static const int surfaceColor = 0xFF2D2D2D; // 라이트 다크
}
