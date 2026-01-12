import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_face_future/domain/entities/analysis_result_entity.dart';

void main() {
  group('AnalysisResultEntity', () {
    test('should create entity with all required fields', () {
      const entity = AnalysisResultEntity(
        job: '개발자',
        salary: '5000만원',
        comment: '코딩 천재!',
        features: FaceFeaturesEntity(
          eyes: '집중하는 눈',
          nose: '날카로운 코',
          mouth: '굳게 다문 입',
          vibe: '진지한 분위기',
        ),
        stats: StatsEntity(
          creativity: 85,
          analysis: 90,
          leadership: 70,
          communication: 75,
          stamina: 65,
          luck: 80,
        ),
        jobInfo: JobInfoEntity(
          description: '소프트웨어를 만드는 사람',
          skills: ['프로그래밍', '문제해결'],
          departments: ['컴퓨터공학과'],
        ),
      );

      expect(entity.job, '개발자');
      expect(entity.salary, '5000만원');
      expect(entity.features.eyes, '집중하는 눈');
      expect(entity.stats.creativity, 85);
      expect(entity.jobInfo.skills.length, 2);
    });
  });

  group('StatsEntity', () {
    test('toList should return all stats in correct order', () {
      const stats = StatsEntity(
        creativity: 10,
        analysis: 20,
        leadership: 30,
        communication: 40,
        stamina: 50,
        luck: 60,
      );

      final list = stats.toList();

      expect(list.length, 6);
      expect(list[0], 10.0); // creativity
      expect(list[1], 20.0); // analysis
      expect(list[2], 30.0); // leadership
      expect(list[3], 40.0); // communication
      expect(list[4], 50.0); // stamina
      expect(list[5], 60.0); // luck
    });

    test('toList should work with boundary values', () {
      const stats = StatsEntity(
        creativity: 0,
        analysis: 100,
        leadership: 1,
        communication: 99,
        stamina: 50,
        luck: 50,
      );

      final list = stats.toList();

      expect(list[0], 0.0);
      expect(list[1], 100.0);
    });
  });

  group('FaceFeaturesEntity', () {
    test('should store all facial features', () {
      const features = FaceFeaturesEntity(
        eyes: '큰 눈',
        nose: '작은 코',
        mouth: '웃는 입',
        vibe: '밝은 느낌',
      );

      expect(features.eyes, '큰 눈');
      expect(features.nose, '작은 코');
      expect(features.mouth, '웃는 입');
      expect(features.vibe, '밝은 느낌');
    });
  });

  group('JobInfoEntity', () {
    test('should store job information', () {
      const jobInfo = JobInfoEntity(
        description: '직업 설명',
        skills: ['스킬1', '스킬2', '스킬3'],
        departments: ['학과A', '학과B'],
      );

      expect(jobInfo.description, '직업 설명');
      expect(jobInfo.skills.length, 3);
      expect(jobInfo.departments.length, 2);
    });

    test('should handle empty lists', () {
      const jobInfo = JobInfoEntity(
        description: '설명만',
        skills: [],
        departments: [],
      );

      expect(jobInfo.skills, isEmpty);
      expect(jobInfo.departments, isEmpty);
    });
  });
}
