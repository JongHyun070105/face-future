import 'dart:io';
import '../entities/analysis_result_entity.dart';

/// 얼굴 분석 Repository 인터페이스 (Domain Layer)
abstract class FaceAnalysisRepository {
  /// 얼굴 이미지가 유효한지 검증
  Future<bool> validateFaceImage(File imageFile);

  /// 얼굴 이미지 분석
  Future<AnalysisResultEntity> analyzeImage(
    File imageFile, {
    required bool seriousMode,
  });
}
