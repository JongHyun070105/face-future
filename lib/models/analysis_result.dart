/// AI 분석 결과 모델
class AnalysisResult {
  final String job;
  final String salary;
  final String comment;
  final FaceFeatures features;
  final Stats stats;
  final JobInfo jobInfo;
  final String luckyItem;

  AnalysisResult({
    required this.job,
    required this.salary,
    required this.comment,
    required this.features,
    required this.stats,
    required this.jobInfo,
    required this.luckyItem,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      job: json['job'] ?? '알 수 없음',
      salary: json['salary'] ?? '측정 불가',
      comment: json['comment'] ?? '',
      features: FaceFeatures.fromJson(json['features'] ?? {}),
      stats: Stats.fromJson(json['stats'] ?? {}),
      jobInfo: JobInfo.fromJson(json['job_info'] ?? {}),
      luckyItem: json['lucky_item'] ?? '없음',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job': job,
      'salary': salary,
      'comment': comment,
      'features': features.toJson(),
      'stats': stats.toJson(),
      'job_info': jobInfo.toJson(),
      'lucky_item': luckyItem,
    };
  }
}

/// 얼굴 특징 분석 결과
class FaceFeatures {
  final String eyes;
  final String nose;
  final String mouth;
  final String vibe;

  FaceFeatures({
    required this.eyes,
    required this.nose,
    required this.mouth,
    required this.vibe,
  });

  factory FaceFeatures.fromJson(Map<String, dynamic> json) {
    return FaceFeatures(
      eyes: json['eyes'] ?? '',
      nose: json['nose'] ?? '',
      mouth: json['mouth'] ?? '',
      vibe: json['vibe'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'eyes': eyes, 'nose': nose, 'mouth': mouth, 'vibe': vibe};
  }
}

/// 능력치 스탯
class Stats {
  final int creativity;
  final int analysis;
  final int leadership;
  final int communication;
  final int stamina;
  final int luck;

  Stats({
    required this.creativity,
    required this.analysis,
    required this.leadership,
    required this.communication,
    required this.stamina,
    required this.luck,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      creativity: json['creativity'] ?? 50,
      analysis: json['analysis'] ?? 50,
      leadership: json['leadership'] ?? 50,
      communication: json['communication'] ?? 50,
      stamina: json['stamina'] ?? 50,
      luck: json['luck'] ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creativity': creativity,
      'analysis': analysis,
      'leadership': leadership,
      'communication': communication,
      'stamina': stamina,
      'luck': luck,
    };
  }

  /// 레이더 차트용 리스트 반환
  List<double> toList() {
    return [
      creativity.toDouble(),
      analysis.toDouble(),
      leadership.toDouble(),
      communication.toDouble(),
      stamina.toDouble(),
      luck.toDouble(),
    ];
  }
}

/// 직업 상세 정보
class JobInfo {
  final String description;
  final List<String> skills;
  final List<String> departments;

  JobInfo({
    required this.description,
    required this.skills,
    required this.departments,
  });

  factory JobInfo.fromJson(Map<String, dynamic> json) {
    return JobInfo(
      description: json['description'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      departments: List<String>.from(json['departments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'skills': skills,
      'departments': departments,
    };
  }
}
