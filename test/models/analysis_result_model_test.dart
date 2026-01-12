import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_face_future/data/models/analysis_result_model.dart';

void main() {
  group('AnalysisResultModel', () {
    test('fromJson should parse complete JSON correctly', () {
      final json = {
        'job': '데이터 사이언티스트',
        'salary': '약 6,000만원',
        'comment': '분석력이 뛰어나네요!',
        'features': {
          'eyes': '날카로운 눈',
          'nose': '높은 코',
          'mouth': '굳은 입',
          'vibe': '지적인 분위기',
        },
        'stats': {
          'creativity': 80,
          'analysis': 95,
          'leadership': 70,
          'communication': 85,
          'stamina': 60,
          'luck': 75,
        },
        'job_info': {
          'description': '데이터를 분석하는 직업입니다.',
          'skills': ['Python', '통계학', '머신러닝'],
          'departments': ['컴퓨터공학과', '통계학과'],
        },
      };

      final model = AnalysisResultModel.fromJson(json);

      expect(model.job, '데이터 사이언티스트');
      expect(model.salary, '약 6,000만원');
      expect(model.comment, '분석력이 뛰어나네요!');
      expect(model.features.eyes, '날카로운 눈');
      expect(model.stats.analysis, 95);
      expect(model.jobInfo.skills.length, 3);
    });

    test('fromJson should handle empty JSON with defaults', () {
      final json = <String, dynamic>{};

      final model = AnalysisResultModel.fromJson(json);

      expect(model.job, '알 수 없음');
      expect(model.salary, '측정 불가');
      expect(model.comment, '');
      expect(model.stats.creativity, 50);
      expect(model.stats.analysis, 50);
    });

    test('fromJson should handle partial JSON', () {
      final json = {
        'job': '프로그래머',
        'stats': {'creativity': 100},
      };

      final model = AnalysisResultModel.fromJson(json);

      expect(model.job, '프로그래머');
      expect(model.salary, '측정 불가');
      expect(model.stats.creativity, 100);
      expect(model.stats.analysis, 50); // default
    });

    test('toEntity should convert model to entity correctly', () {
      final model = AnalysisResultModel(
        job: '테스트 직업',
        salary: '1억원',
        comment: '테스트 코멘트',
        features: const FaceFeaturesModel(
          eyes: '큰 눈',
          nose: '작은 코',
          mouth: '웃는 입',
          vibe: '밝은 분위기',
        ),
        stats: const StatsModel(
          creativity: 90,
          analysis: 80,
          leadership: 70,
          communication: 60,
          stamina: 50,
          luck: 40,
        ),
        jobInfo: const JobInfoModel(
          description: '테스트 설명',
          skills: ['스킬1', '스킬2'],
          departments: ['학과1'],
        ),
      );

      final entity = model.toEntity();

      expect(entity.job, '테스트 직업');
      expect(entity.salary, '1억원');
      expect(entity.features.eyes, '큰 눈');
      expect(entity.stats.creativity, 90);
      expect(entity.jobInfo.skills, ['스킬1', '스킬2']);
    });
  });

  group('StatsModel', () {
    test('fromJson should parse all stats', () {
      final json = {
        'creativity': 85,
        'analysis': 90,
        'leadership': 75,
        'communication': 80,
        'stamina': 70,
        'luck': 95,
      };

      final stats = StatsModel.fromJson(json);

      expect(stats.creativity, 85);
      expect(stats.analysis, 90);
      expect(stats.leadership, 75);
      expect(stats.communication, 80);
      expect(stats.stamina, 70);
      expect(stats.luck, 95);
    });

    test('toEntity.toList should return correct order', () {
      const stats = StatsModel(
        creativity: 10,
        analysis: 20,
        leadership: 30,
        communication: 40,
        stamina: 50,
        luck: 60,
      );

      final entity = stats.toEntity();
      final list = entity.toList();

      expect(list, [10.0, 20.0, 30.0, 40.0, 50.0, 60.0]);
    });
  });

  group('FaceFeaturesModel', () {
    test('fromJson should parse all features', () {
      final json = {
        'eyes': '동그란 눈',
        'nose': '오똑한 코',
        'mouth': '작은 입',
        'vibe': '귀여운 분위기',
      };

      final features = FaceFeaturesModel.fromJson(json);

      expect(features.eyes, '동그란 눈');
      expect(features.nose, '오똑한 코');
      expect(features.mouth, '작은 입');
      expect(features.vibe, '귀여운 분위기');
    });
  });

  group('JobInfoModel', () {
    test('fromJson should parse skills and departments as lists', () {
      final json = {
        'description': '직업 설명입니다.',
        'skills': ['기술1', '기술2', '기술3'],
        'departments': ['학과A', '학과B'],
      };

      final jobInfo = JobInfoModel.fromJson(json);

      expect(jobInfo.description, '직업 설명입니다.');
      expect(jobInfo.skills.length, 3);
      expect(jobInfo.departments.length, 2);
      expect(jobInfo.skills.first, '기술1');
    });

    test('fromJson should handle empty lists', () {
      final json = {'description': '설명만 있음'};

      final jobInfo = JobInfoModel.fromJson(json);

      expect(jobInfo.description, '설명만 있음');
      expect(jobInfo.skills, isEmpty);
      expect(jobInfo.departments, isEmpty);
    });
  });
}
