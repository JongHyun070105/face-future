/// 앱 문자열 상수
class AppStrings {
  // 앱 기본 정보
  static const String appName = 'Face Future';
  static const String appSubtitle = 'AI 관상으로 보는 나의 미래';

  // 홈 화면
  static const String funMode = '🎭 재미 모드';
  static const String seriousMode = '📚 진지 모드';
  static const String checkMyFuture = '🔮 나의 미래 확인하기';

  // 동의 화면
  static const String consentTitle = '📸 개인정보 동의';
  static const String consentSubtitle = 'AI 분석을 위해 얼굴 사진을 촬영합니다';
  static const String agreeAndStart = '동의하고 시작하기';
  static const String consentCheckboxText = '위 내용을 확인했으며, 개인정보 처리에 동의합니다.';

  // 이미지 선택
  static const String takePhoto = '카메라로 촬영';
  static const String chooseFromGallery = '갤러리에서 선택';

  // 결과 화면
  static const String saveResult = '결과 저장';
  static const String tryAgain = '다시 하기';
  static const String savedSuccess = '결과가 저장되었습니다!';
  static const String savedFailed = '저장에 실패했습니다';

  // 분석 화면
  static const String analyzing = '분석 중...';
  static const String aiFeatureAnalysis = 'AI가 분석한 당신의 특징';
  static const String statsAnalysis = '능력치 분석';
  static const String jobInfo = '직업 정보';
  static const String requiredSkills = '필요 역량';
  static const String relatedDepartments = '관련 학과';

  // 에러 메시지
  static const String imageLoadFailed = '이미지를 불러오는데 실패했습니다.';
  static const String aiResponseEmpty = 'AI 응답이 비어있습니다';
  static const String noFaceDetected =
      '사람 얼굴이 감지되지 않았습니다.\n얼굴이 잘 보이는 사진으로 다시 시도해주세요!';

  // 개인정보 동의 내용
  static const String consentEducation = '교육 목적 앱';
  static const String consentEducationDesc =
      '본 앱은 인공지능과 빅데이터를 체험하기 위한 교육용 앱입니다.';
  static const String consentTransfer = '이미지 전송';
  static const String consentTransferDesc =
      '촬영된 사진은 Google Gemini AI에게 전송되어 분석됩니다.';
  static const String consentDelete = '즉시 삭제';
  static const String consentDeleteDesc =
      '분석이 완료되면 사진은 즉시 삭제됩니다. 어떠한 서버에도 저장되지 않습니다.';
  static const String consentEncryption = '암호화 전송';
  static const String consentEncryptionDesc =
      '모든 데이터는 HTTPS를 통해 암호화되어 안전하게 전송됩니다.';
  static const String consentDisclaimer = '결과 안내';
  static const String consentDisclaimerDesc =
      '분석 결과는 재미를 위한 것이며, 실제 미래를 예측하는 것이 아닙니다.';

  // 능력치 라벨
  static const String creativity = '창의력';
  static const String analysis = '분석력';
  static const String leadership = '리더십';
  static const String communication = '소통력';
  static const String stamina = '체력';
  static const String luck = '운';

  // 특징 분석 라벨
  static const String eyes = '👁️ 눈';
  static const String nose = '👃 코';
  static const String mouth = '👄 입';
  static const String vibe = '✨ 분위기';
}
