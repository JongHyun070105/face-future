import 'dart:io';
import '../../domain/entities/analysis_result_entity.dart';
import '../../domain/repositories/face_analysis_repository.dart';
import '../datasources/gemini_remote_datasource.dart';

/// FaceAnalysisRepository 구현체
class FaceAnalysisRepositoryImpl implements FaceAnalysisRepository {
  final GeminiRemoteDataSource remoteDataSource;

  FaceAnalysisRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> validateFaceImage(File imageFile) async {
    return remoteDataSource.validateFace(imageFile);
  }

  @override
  Future<AnalysisResultEntity> analyzeImage(
    File imageFile, {
    required bool seriousMode,
  }) async {
    final model = await remoteDataSource.analyzeImage(
      imageFile,
      seriousMode: seriousMode,
    );
    return model.toEntity();
  }
}
