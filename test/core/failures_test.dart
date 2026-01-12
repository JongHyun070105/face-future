import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_face_future/core/error/failures.dart';

void main() {
  group('Failure Types', () {
    test('FaceValidationFailure should have default message', () {
      const failure = FaceValidationFailure();
      expect(failure.message, '사람 얼굴이 감지되지 않았습니다.');
    });

    test('FaceValidationFailure should accept custom message', () {
      const failure = FaceValidationFailure('얼굴을 찾을 수 없습니다.');
      expect(failure.message, '얼굴을 찾을 수 없습니다.');
    });

    test('NetworkFailure should have default message', () {
      const failure = NetworkFailure();
      expect(failure.message, '인터넷 연결을 확인해주세요.');
    });

    test('ServerFailure should have default message', () {
      const failure = ServerFailure();
      expect(failure.message, '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    });

    test('ParsingFailure should have default message', () {
      const failure = ParsingFailure();
      expect(failure.message, 'AI 응답을 처리하지 못했습니다. 다시 시도해주세요.');
    });

    test('TimeoutFailure should have default message', () {
      const failure = TimeoutFailure();
      expect(failure.message, '서버 응답이 느립니다. 다시 시도해주세요.');
    });

    test('Failure toString should include details if provided', () {
      const failure = ServerFailure('서버 오류', 'HTTP 500');
      expect(failure.toString(), '서버 오류 (HTTP 500)');
    });

    test('Failure toString should only show message if no details', () {
      const failure = NetworkFailure();
      expect(failure.toString(), '인터넷 연결을 확인해주세요.');
    });
  });

  group('AppException', () {
    test('should wrap Failure correctly', () {
      const failure = NetworkFailure('네트워크 오류');
      const exception = AppException(failure);

      expect(exception.failure, failure);
      expect(exception.message, '네트워크 오류');
    });

    test('toString should delegate to failure', () {
      const failure = ServerFailure('에러', '상세 정보');
      const exception = AppException(failure);

      expect(exception.toString(), '에러 (상세 정보)');
    });
  });
}
