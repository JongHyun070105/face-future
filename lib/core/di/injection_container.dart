import '../../data/datasources/gemini_remote_datasource.dart';
import '../../data/repositories/face_analysis_repository_impl.dart';
import '../../domain/repositories/face_analysis_repository.dart';
import '../../domain/usecases/analyze_face_usecase.dart';
import '../config/app_config.dart';

/// 의존성 주입 컨테이너 (간단한 Service Locator 패턴)
class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();
  factory DependencyInjection() => _instance;
  DependencyInjection._internal();

  // 싱글톤 인스턴스들
  GeminiRemoteDataSource? _geminiDataSource;
  FaceAnalysisRepository? _faceAnalysisRepository;
  AnalyzeFaceUseCase? _analyzeFaceUseCase;

  /// Gemini DataSource
  GeminiRemoteDataSource get geminiDataSource {
    _geminiDataSource ??= GeminiRemoteDataSource(
      apiKey: AppConfig.geminiApiKey,
      modelName: AppConfig.geminiModel,
    )..initialize();
    return _geminiDataSource!;
  }

  /// Face Analysis Repository
  FaceAnalysisRepository get faceAnalysisRepository {
    _faceAnalysisRepository ??= FaceAnalysisRepositoryImpl(
      remoteDataSource: geminiDataSource,
    );
    return _faceAnalysisRepository!;
  }

  /// Analyze Face UseCase
  AnalyzeFaceUseCase get analyzeFaceUseCase {
    _analyzeFaceUseCase ??= AnalyzeFaceUseCase(faceAnalysisRepository);
    return _analyzeFaceUseCase!;
  }

  /// 리셋 (테스트용)
  void reset() {
    _geminiDataSource = null;
    _faceAnalysisRepository = null;
    _analyzeFaceUseCase = null;
  }
}

/// 전역 DI 인스턴스
final di = DependencyInjection();
