/// 애플리케이션 에러 타입
abstract class Failure {
  final String message;
  final String? details;
  const Failure(this.message, [this.details]);

  @override
  String toString() => details != null ? '$message ($details)' : message;
}

/// 얼굴 검증 실패
class FaceValidationFailure extends Failure {
  const FaceValidationFailure([
    super.message = '사람 얼굴이 감지되지 않았습니다.',
    super.details,
  ]);
}

/// AI 분석 실패
class AnalysisFailure extends Failure {
  const AnalysisFailure([super.message = 'AI 분석에 실패했습니다.', super.details]);
}

/// 네트워크 실패
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '인터넷 연결을 확인해주세요.', super.details]);
}

/// 이미지 처리 실패
class ImageFailure extends Failure {
  const ImageFailure([super.message = '이미지를 처리하는데 실패했습니다.', super.details]);
}

/// 서버 오류
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
    super.details,
  ]);
}

/// JSON 파싱 오류
class ParsingFailure extends Failure {
  const ParsingFailure([
    super.message = 'AI 응답을 처리하지 못했습니다. 다시 시도해주세요.',
    super.details,
  ]);
}

/// 타임아웃 오류
class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = '서버 응답이 느립니다. 다시 시도해주세요.',
    super.details,
  ]);
}

/// 앱 예외 (Exception으로 throw 가능)
class AppException implements Exception {
  final Failure failure;
  const AppException(this.failure);

  String get message => failure.message;

  @override
  String toString() => failure.toString();
}
