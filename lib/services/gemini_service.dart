import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/app_config.dart';
import '../models/analysis_result.dart';

/// Gemini API 통신 서비스
class GeminiService {
  late final GenerativeModel _model;
  late final GenerativeModel _validationModel;
  bool _isInitialized = false;

  /// 서비스 초기화
  void initialize() {
    if (_isInitialized) return;

    _model = GenerativeModel(
      model: AppConfig.geminiModel,
      apiKey: AppConfig.geminiApiKey,
      systemInstruction: Content.text(_systemPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 1.0, // 더 다양한 결과를 위해 상향
      ),
    );

    _validationModel = GenerativeModel(
      model: AppConfig.geminiModel,
      apiKey: AppConfig.geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.1,
      ),
    );

    _isInitialized = true;
  }

  /// 얼굴 이미지인지 검증
  Future<bool> validateFaceImage(File imageFile) async {
    if (!_isInitialized) initialize();

    final imageBytes = await imageFile.readAsBytes();
    final imagePart = DataPart('image/jpeg', imageBytes);

    const validationPrompt = '''
이 이미지에 사람의 얼굴이 있는지 확인해줘.
JSON 형식으로 답변해:
{"is_face": true/false, "reason": "이유"}
''';

    final content = Content.multi([TextPart(validationPrompt), imagePart]);
    final response = await _validationModel.generateContent([content]);
    final jsonText = response.text;

    if (jsonText == null || jsonText.isEmpty) {
      return false;
    }

    try {
      final jsonData = jsonDecode(jsonText) as Map<String, dynamic>;
      return jsonData['is_face'] == true;
    } catch (e) {
      return false;
    }
  }

  /// 얼굴 이미지 분석
  Future<AnalysisResult> analyzeImage(
    File imageFile, {
    bool seriousMode = false,
  }) async {
    if (!_isInitialized) initialize();

    final imageBytes = await imageFile.readAsBytes();
    final imagePart = DataPart('image/jpeg', imageBytes);

    final promptText = seriousMode
        ? '이 얼굴 사진을 분석해줘. [진지 모드]로 분석해. 다양한 직업군에서 이 사람에게 어울리는 직업을 추천해. 매번 다른 직업을 추천해줘. (${DateTime.now().millisecondsSinceEpoch})'
        : '이 얼굴 사진을 분석해줘! [재미 모드]로 분석해. 재미있고 특이한 직업을 추천해줘! (${DateTime.now().millisecondsSinceEpoch})';

    final content = Content.multi([TextPart(promptText), imagePart]);

    final response = await _model.generateContent([content]);
    final jsonText = response.text;

    if (jsonText == null || jsonText.isEmpty) {
      throw Exception('AI 응답이 비어있습니다');
    }

    final jsonData = jsonDecode(jsonText) as Map<String, dynamic>;
    return AnalysisResult.fromJson(jsonData);
  }

  /// 시스템 프롬프트
  static const String _systemPrompt = '''
너는 20년 경력의 용한 관상가이자 빅데이터 분석가야.

[역할]
사용자가 보내준 얼굴 사진을 분석하여 미래의 직업과 연봉을 예측해.

[중요 규칙]
- 매번 다른 직업을 추천해야 함! 같은 직업 반복 금지!
- 얼굴의 특징을 보고 정말 어울리는 직업을 창의적으로 생각해

[분석 방법]
1. 얼굴의 외모적 특징(눈, 코, 입, 얼굴형, 표정, 분위기)을 관찰해.
2. 각 특징이 어떤 성격/능력과 연결되는지 관상학적으로 해석해.
3. 이를 바탕으로 가장 어울리는 직업을 추천해.

[직업 추천 가이드 - 모드별 차별화 필수]
1. 진지 모드 (Serious Mode):
   - 얼굴 특징을 깊이 분석하고, 그 특징에서 연상되는 직업을 창의적으로 도출해.
   - 특정 분야에 편향되지 말고 모든 산업군을 고려해 (IT, 제조, 서비스, 예술, 의료, 교육, 기능직, 1차산업 등)
   - 예시 목록에서 고르지 말고, 그 사람의 얼굴에서 느껴지는 인상에 맞는 직업을 직접 생각해내.
   - 연봉은 짧게 (예: '약 4,000만원')
   - 직업명은 20자 이내
   - 말투: 전문적이고 신뢰감 있게

2. 재미 모드 (Fun Mode):
   - 얼굴 특징에서 엉뚱한 연상을 해서 재미있는 직업을 추천해.
   - 진짜 존재하는 직업이어야 하지만, 잘 알려지지 않은 특이한 직업도 OK.
   - 설명과 코멘트는 유쾌하고 재치있게
   - 연봉은 매번 다르게 유머러스하게 표현해 (같은 표현 반복 금지!)
   - 말투: MZ 감성으로 유쾌하게

[중요 규칙]
- 절대 같은 직업을 반복 추천하지 마!
- 미리 정해진 목록에서 고르지 말고, 얼굴을 보고 창의적으로 생각해!
- 눈, 코, 입, 분위기 각각의 특징이 어떤 직업적 능력과 연결되는지 논리적으로 연결해.

[필수 출력 형식 - JSON]
{
  "job": "직업명 (20자 이내)",
  "salary": "예상 연봉 (짧게)",
  "comment": "한줄 코멘트 (모드에 맞춰 진지하거나 웃기게)",
  "features": {
    "eyes": "눈에 대한 분석",
    "nose": "코에 대한 분석",
    "mouth": "입에 대한 분석",
    "vibe": "전체적인 분위기"
  },
  "stats": {
    "creativity": 1-100,
    "analysis": 1-100,
    "leadership": 1-100,
    "communication": 1-100,
    "stamina": 1-100,
    "luck": 1-100
  },
  "job_info": {
    "description": "이 직업이 무엇을 하는지 구체적으로 설명 (2-3문장, 실제로 어떤 일을 하는지 중학생도 이해할 수 있게)",
    "skills": ["역량1", "역량2", "역량3"],
    "departments": ["학과1", "학과2"]
  }
}
''';
}
