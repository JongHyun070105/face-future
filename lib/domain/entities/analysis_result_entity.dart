/// 분석 결과 엔티티 (Domain Layer - 순수 Dart)
class AnalysisResultEntity {
  final String job;
  final String salary;
  final String comment;
  final FaceFeaturesEntity features;
  final StatsEntity stats;
  final JobInfoEntity jobInfo;

  const AnalysisResultEntity({
    required this.job,
    required this.salary,
    required this.comment,
    required this.features,
    required this.stats,
    required this.jobInfo,
  });
}

/// 얼굴 특징 엔티티
class FaceFeaturesEntity {
  final String eyes;
  final String nose;
  final String mouth;
  final String vibe;

  const FaceFeaturesEntity({
    required this.eyes,
    required this.nose,
    required this.mouth,
    required this.vibe,
  });
}

/// 능력치 엔티티
class StatsEntity {
  final int creativity;
  final int analysis;
  final int leadership;
  final int communication;
  final int stamina;
  final int luck;

  const StatsEntity({
    required this.creativity,
    required this.analysis,
    required this.leadership,
    required this.communication,
    required this.stamina,
    required this.luck,
  });

  /// 레이더 차트용 리스트
  List<double> toList() => [
    creativity.toDouble(),
    analysis.toDouble(),
    leadership.toDouble(),
    communication.toDouble(),
    stamina.toDouble(),
    luck.toDouble(),
  ];
}

/// 직업 정보 엔티티
class JobInfoEntity {
  final String description;
  final List<String> skills;
  final List<String> departments;

  const JobInfoEntity({
    required this.description,
    required this.skills,
    required this.departments,
  });
}
