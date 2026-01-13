import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/analysis_result_model.dart';

/// 히스토리 저장용 모델 (날짜 + 모드 포함)
class HistoryItemModel {
  final AnalysisResultModel result;
  final DateTime createdAt;
  final bool isSeriousMode;

  const HistoryItemModel({
    required this.result,
    required this.createdAt,
    required this.isSeriousMode,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) {
    return HistoryItemModel(
      result: AnalysisResultModel.fromJson(json['result'] ?? {}),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      isSeriousMode: json['is_serious_mode'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': {
        'job': result.job,
        'salary': result.salary,
        'comment': result.comment,
        'features': {
          'eyes': result.features.eyes,
          'nose': result.features.nose,
          'mouth': result.features.mouth,
          'vibe': result.features.vibe,
        },
        'stats': {
          'creativity': result.stats.creativity,
          'analysis': result.stats.analysis,
          'leadership': result.stats.leadership,
          'communication': result.stats.communication,
          'stamina': result.stats.stamina,
          'luck': result.stats.luck,
        },
        'job_info': {
          'description': result.jobInfo.description,
          'skills': result.jobInfo.skills,
          'departments': result.jobInfo.departments,
        },
      },
      'created_at': createdAt.toIso8601String(),
      'is_serious_mode': isSeriousMode,
    };
  }
}

/// 히스토리 로컬 저장소
class HistoryLocalDataSource {
  static const String _historyKey = 'analysis_history';
  static const int _maxItems = 20;

  /// 히스토리 목록 조회
  Future<List<HistoryItemModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map(
            (json) => HistoryItemModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 히스토리에 새 항목 추가
  Future<void> addToHistory(
    AnalysisResultModel result,
    bool isSeriousMode,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    // 새 항목 생성
    final newItem = HistoryItemModel(
      result: result,
      createdAt: DateTime.now(),
      isSeriousMode: isSeriousMode,
    );

    // 맨 앞에 추가
    history.insert(0, newItem);

    // 최대 개수 초과 시 오래된 것 삭제
    if (history.length > _maxItems) {
      history.removeRange(_maxItems, history.length);
    }

    // 저장
    final jsonList = history.map((item) => item.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  /// 특정 항목 삭제
  Future<void> removeFromHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      final jsonList = history.map((item) => item.toJson()).toList();
      await prefs.setString(_historyKey, jsonEncode(jsonList));
    }
  }

  /// 전체 히스토리 삭제
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
