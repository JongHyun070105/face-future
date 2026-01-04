import 'dart:io';
import '../entities/analysis_result_entity.dart';
import '../repositories/face_analysis_repository.dart';

/// 얼굴 분석 UseCase
class AnalyzeFaceUseCase {
  final FaceAnalysisRepository repository;

  AnalyzeFaceUseCase(this.repository);

  /// 얼굴 분석 실행
  Future<AnalysisResultEntity> execute(
    File imageFile, {
    required bool seriousMode,
  }) async {
    // 1. 얼굴 유효성 검사
    final isValidFace = await repository.validateFaceImage(imageFile);
    if (!isValidFace) {
      throw FaceValidationException('사람 얼굴이 감지되지 않았습니다.');
    }

    // 2. 얼굴 분석
    return repository.analyzeImage(imageFile, seriousMode: seriousMode);
  }
}

/// 얼굴 검증 예외
class FaceValidationException implements Exception {
  final String message;
  FaceValidationException(this.message);

  @override
  String toString() => message;
}
