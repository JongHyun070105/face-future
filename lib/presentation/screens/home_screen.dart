import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_config.dart';
import '../../core/config/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'consent_screen.dart';
import 'loading_screen.dart';

/// 메인 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isSeriousMode = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // 로고 및 타이틀
                  _buildTitle(),
                  const SizedBox(height: 16),
                  // 부제
                  Text(
                    AppConfig.appSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(AppTheme.accentColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),
                  // 모드 선택 토글
                  _buildModeToggle(),
                  const SizedBox(height: 32),
                  // 메인 버튼
                  _buildMainButton(),
                  const Spacer(flex: 1),
                  // 하단 정보 버튼
                  _buildInfoButton(),
                  const SizedBox(height: 16),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '🔮 ${AppConfig.appName}',
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Color(AppTheme.secondaryColor),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      decoration: AppTheme.glassmorphism(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeOption('🎭 재미 모드', !_isSeriousMode, () {
            setState(() => _isSeriousMode = false);
          }),
          const SizedBox(width: 8),
          Container(width: 1, height: 24, color: Colors.white24),
          const SizedBox(width: 8),
          _buildModeOption('📚 진지 모드', _isSeriousMode, () {
            setState(() => _isSeriousMode = true);
          }),
        ],
      ),
    );
  }

  Widget _buildModeOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(AppTheme.primaryColor).withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.white60,
          ),
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _handleStartButton() async {
    final prefs = await SharedPreferences.getInstance();
    final hasConsented = prefs.getBool('hasConsented') ?? false;

    if (hasConsented) {
      // 이미 동의한 경우 바로 이미지 선택
      _showImageSourceDialog();
    } else {
      // 동의 안 한 경우 동의 화면으로 이동
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ConsentScreen(isSeriousMode: _isSeriousMode),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    ImageSourceBottomSheet.show(
      context,
      onCameraTap: () => _pickImage(ImageSource.camera),
      onGalleryTap: () => _pickImage(ImageSource.gallery),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoadingScreen(
              imageFile: File(image.path),
              isSeriousMode: _isSeriousMode,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이미지를 가져오는데 실패했습니다')));
      }
    }
  }

  Widget _buildMainButton() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(AppTheme.primaryColor).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _handleStartButton(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(AppTheme.primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            '🔮 나의 미래 확인하기',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoButton() {
    return TextButton.icon(
      onPressed: () => _showInfoDialog(),
      icon: const Icon(Icons.info_outline, size: 18),
      label: const Text('이 앱은 어떻게 작동하나요?'),
      style: TextButton.styleFrom(foregroundColor: Colors.white60),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(AppTheme.surfaceColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '📚 AI 관상 분석의 원리',
          style: TextStyle(color: Color(AppTheme.secondaryColor)),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _InfoStep(
                number: '1️⃣',
                title: '이미지 입력',
                description: '당신의 얼굴 사진이 AI에게 전달됩니다.',
              ),
              SizedBox(height: 16),
              _InfoStep(
                number: '2️⃣',
                title: '특징 추출 (Feature Extraction)',
                description: 'AI가 눈, 코, 입의 위치와 모양, 표정을 분석합니다.',
              ),
              SizedBox(height: 16),
              _InfoStep(
                number: '3️⃣',
                title: '패턴 매칭 (Pattern Matching)',
                description: '수십억 개의 학습 데이터에서 유사한 패턴을 찾습니다.',
              ),
              SizedBox(height: 16),
              _InfoStep(
                number: '4️⃣',
                title: '예측 (Prediction)',
                description: '분석된 특징을 바탕으로 가장 어울리는 직업을 예측합니다.',
              ),
              SizedBox(height: 24),
              Divider(color: Colors.white24),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Text('알아두세요!', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '이 결과는 재미를 위한 것이며, 실제 미래를 예측하는 것이 아닙니다. AI도 틀릴 수 있어요! (이것을 \'AI 환각\'이라고 해요)',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

class _InfoStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _InfoStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
