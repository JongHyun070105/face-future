import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/analysis_result_model.dart';

/// Gemini API 원격 데이터소스
class GeminiRemoteDataSource {
  late final GenerativeModel _model;
  late final GenerativeModel _validationModel;
  bool _isInitialized = false;

  final String apiKey;
  final String modelName;

  GeminiRemoteDataSource({required this.apiKey, required this.modelName});

  /// 초기화
  void initialize() {
    if (_isInitialized) return;

    _model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      systemInstruction: Content.text(_systemPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 1.0,
      ),
    );

    _validationModel = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.1,
      ),
    );

    _isInitialized = true;
  }

  /// 얼굴 이미지 검증
  Future<bool> validateFace(File imageFile) async {
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

    if (jsonText == null || jsonText.isEmpty) return false;

    try {
      final jsonData = jsonDecode(jsonText) as Map<String, dynamic>;
      return jsonData['is_face'] == true;
    } catch (e) {
      return false;
    }
  }

  /// 얼굴 분석
  Future<AnalysisResultModel> analyzeImage(
    File imageFile, {
    required bool seriousMode,
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
    return AnalysisResultModel.fromJson(jsonData);
  }

  static const String _systemPrompt = '''
너는 20년 경력의 용한 관상가이자 빅데이터 분석가야.

[역할]
사용자가 보내준 얼굴 사진을 분석하여 미래의 직업과 연봉을 예측해.

[핵심 규칙]
- 매번 완전히 다른 직업 추천! 같은 직업 절대 반복 금지!
- 얼굴 특징을 보고 창의적으로 직업 연상

[분석 방법]
1. 얼굴의 외모적 특징(눈, 코, 입, 얼굴형, 표정, 분위기)을 관찰
2. 각 특징이 어떤 성격/능력과 연결되는지 관상학적으로 해석
3. 이를 바탕으로 가장 어울리는 직업 추천

[모드별 직업 추천 가이드]

★ 진지 모드 (Serious Mode) ★
- 반드시 다양한 산업군에서 골고루 추천할 것!
- 산업군 예시 (매번 다른 분야에서 선택):
  * IT/테크: 데이터 사이언티스트, UX 디자이너, 보안 전문가
  * 의료/바이오: 외과의사, 물리치료사, 유전공학자
  * 법률/행정: 판사, 외교관, 정책 분석가
  * 금융/경제: 투자은행가, 리스크 매니저, 경제학자
  * 예술/문화: 오케스트라 지휘자, 큐레이터, 무대 디자이너
  * 건축/토목: 건축가, 도시계획가, 인테리어 디자이너
  * 교육/연구: 대학교수, 교육컨설턴트, 연구원
  * 제조/엔지니어링: 항공우주 엔지니어, 로봇공학자, 품질관리사
  * 서비스/호스피탈리티: 호텔 총지배인, 소믈리에, 이벤트 플래너
  * 농업/환경: 농업경영인, 환경 컨설턴트, 해양생물학자
- 얼굴 특징과 직업의 연관성을 논리적으로 설명
- 연봉: 현실적으로 (예: '약 5,500만원')
- 말투: 전문적이고 신뢰감 있게

★ 재미 모드 (Fun Mode) ★
- 웃기고 특이한 직업 추천! 하지만 실제로 존재하는 직업이어야 함!
- 재미있는 직업 예시 (참고용, 이 외에도 창의적으로 생각):
  * 전문 줄서기꾼, 개 전용 미용사, 풍선 아티스트
  * 음식 맛 테스터, 침대 시험관, 롤러코스터 테스터
  * 판다 사육사, 경호원 바디더블, 초상화 검시관  
  * 치즈 감별사, 레고 마스터 빌더, 유령의 집 배우
  * 향수 조향사, 도그워커, 게임 테스터, 미스터리 쇼퍼
- 얼굴 특징에서 엉뚱한 연상을 해서 웃긴 설명
- 연봉: 유머러스하게 (예: '시급 10개피', '하루 아이스크림 5개', '월급 무제한 치킨', '연봉 행복 1톤')
- 말투: MZ 감성으로 유쾌하고 장난스럽게

[필수 출력 형식 - JSON]
{
  "job": "직업명 (20자 이내)",
  "salary": "예상 연봉 (모드에 맞게)",
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
    "description": "이 직업이 무엇을 하는지 중학생도 이해할 수 있게 설명 (2-3문장)",
    "skills": ["역량1", "역량2", "역량3"],
    "departments": ["학과1", "학과2"]
  }
}
''';
}
