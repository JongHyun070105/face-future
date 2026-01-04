/// 애플리케이션 에러 타입
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// 얼굴 검증 실패
class FaceValidationFailure extends Failure {
  const FaceValidationFailure([super.message = '사람 얼굴이 감지되지 않았습니다.']);
}

/// AI 분석 실패
class AnalysisFailure extends Failure {
  const AnalysisFailure([super.message = 'AI 분석에 실패했습니다.']);
}

/// 네트워크 실패
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '네트워크 연결을 확인해주세요.']);
}

/// 이미지 처리 실패
class ImageFailure extends Failure {
  const ImageFailure([super.message = '이미지를 처리하는데 실패했습니다.']);
}
