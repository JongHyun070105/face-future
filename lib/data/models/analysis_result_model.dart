import '../../domain/entities/analysis_result_entity.dart';

/// 분석 결과 모델 (Data Layer - JSON 변환 담당)
class AnalysisResultModel {
  final String job;
  final String salary;
  final String comment;
  final FaceFeaturesModel features;
  final StatsModel stats;
  final JobInfoModel jobInfo;

  const AnalysisResultModel({
    required this.job,
    required this.salary,
    required this.comment,
    required this.features,
    required this.stats,
    required this.jobInfo,
  });

  /// JSON에서 모델 생성
  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      job: json['job'] ?? '알 수 없음',
      salary: json['salary'] ?? '측정 불가',
      comment: json['comment'] ?? '',
      features: FaceFeaturesModel.fromJson(json['features'] ?? {}),
      stats: StatsModel.fromJson(json['stats'] ?? {}),
      jobInfo: JobInfoModel.fromJson(json['job_info'] ?? {}),
    );
  }

  /// 모델을 엔티티로 변환
  AnalysisResultEntity toEntity() {
    return AnalysisResultEntity(
      job: job,
      salary: salary,
      comment: comment,
      features: features.toEntity(),
      stats: stats.toEntity(),
      jobInfo: jobInfo.toEntity(),
    );
  }
}

/// 얼굴 특징 모델
class FaceFeaturesModel {
  final String eyes;
  final String nose;
  final String mouth;
  final String vibe;

  const FaceFeaturesModel({
    required this.eyes,
    required this.nose,
    required this.mouth,
    required this.vibe,
  });

  factory FaceFeaturesModel.fromJson(Map<String, dynamic> json) {
    return FaceFeaturesModel(
      eyes: json['eyes'] ?? '',
      nose: json['nose'] ?? '',
      mouth: json['mouth'] ?? '',
      vibe: json['vibe'] ?? '',
    );
  }

  FaceFeaturesEntity toEntity() {
    return FaceFeaturesEntity(eyes: eyes, nose: nose, mouth: mouth, vibe: vibe);
  }
}

/// 능력치 모델
class StatsModel {
  final int creativity;
  final int analysis;
  final int leadership;
  final int communication;
  final int stamina;
  final int luck;

  const StatsModel({
    required this.creativity,
    required this.analysis,
    required this.leadership,
    required this.communication,
    required this.stamina,
    required this.luck,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      creativity: json['creativity'] ?? 50,
      analysis: json['analysis'] ?? 50,
      leadership: json['leadership'] ?? 50,
      communication: json['communication'] ?? 50,
      stamina: json['stamina'] ?? 50,
      luck: json['luck'] ?? 50,
    );
  }

  StatsEntity toEntity() {
    return StatsEntity(
      creativity: creativity,
      analysis: analysis,
      leadership: leadership,
      communication: communication,
      stamina: stamina,
      luck: luck,
    );
  }
}

/// 직업 정보 모델
class JobInfoModel {
  final String description;
  final List<String> skills;
  final List<String> departments;

  const JobInfoModel({
    required this.description,
    required this.skills,
    required this.departments,
  });

  factory JobInfoModel.fromJson(Map<String, dynamic> json) {
    return JobInfoModel(
      description: json['description'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      departments: List<String>.from(json['departments'] ?? []),
    );
  }

  JobInfoEntity toEntity() {
    return JobInfoEntity(
      description: description,
      skills: skills,
      departments: departments,
    );
  }
}
