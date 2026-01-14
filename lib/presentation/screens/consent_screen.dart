import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_theme.dart';
import '../../core/config/app_strings.dart';
import '../widgets/common_widgets.dart';
import 'loading_screen.dart';

/// 개인정보 동의 화면
class ConsentScreen extends StatefulWidget {
  final bool isSeriousMode;

  const ConsentScreen({super.key, required this.isSeriousMode});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _isAgreed = false;
  final ImagePicker _picker = ImagePicker();

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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasConsented', true);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoadingScreen(
              imageFile: File(image.path),
              isSeriousMode: widget.isSeriousMode,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: AppStrings.imageLoadFailed,
          isSuccess: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 뒤로가기 버튼
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white70,
                ),
                const SizedBox(height: 24),
                // 타이틀
                const Text(
                  '📸 개인정보 동의',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'AI 분석을 위해 얼굴 사진을 촬영합니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 40),
                // 동의 내용 카드
                Expanded(
                  child: Container(
                    decoration: AppTheme.glassmorphism(opacity: 0.08),
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoItem(
                            icon: Icons.school,
                            title: '교육 목적 앱',
                            description: '본 앱은 인공지능과 빅데이터를 체험하기 위한 교육용 앱입니다.',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoItem(
                            icon: Icons.cloud_upload,
                            title: '이미지 전송',
                            description:
                                '촬영된 사진은 Google Gemini AI에게 전송되어 분석됩니다.',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoItem(
                            icon: Icons.delete_forever,
                            title: '즉시 삭제',
                            description:
                                '분석이 완료되면 사진은 즉시 삭제됩니다. 어떠한 서버에도 저장되지 않습니다.',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoItem(
                            icon: Icons.security,
                            title: '암호화 전송',
                            description: '모든 데이터는 HTTPS를 통해 암호화되어 안전하게 전송됩니다.',
                          ),
                          const SizedBox(height: 24),
                          _buildInfoItem(
                            icon: Icons.info_outline,
                            title: '결과 안내',
                            description:
                                '분석 결과는 재미를 위한 것이며, 실제 미래를 예측하는 것이 아닙니다.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 동의 체크박스
                GestureDetector(
                  onTap: () => setState(() => _isAgreed = !_isAgreed),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _isAgreed
                          ? const Color(
                              AppTheme.primaryColor,
                            ).withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isAgreed
                            ? const Color(AppTheme.primaryColor)
                            : Colors.white24,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _isAgreed
                                ? const Color(AppTheme.primaryColor)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _isAgreed
                                  ? const Color(AppTheme.primaryColor)
                                  : Colors.white54,
                              width: 2,
                            ),
                          ),
                          child: _isAgreed
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            '위 내용을 확인했으며, 개인정보 처리에 동의합니다.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 동의 버튼
                SizedBox(
                  width: double.infinity,
                  child: AnimatedOpacity(
                    opacity: _isAgreed ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: _isAgreed ? _showImageSourceDialog : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '동의하고 시작하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(AppTheme.primaryColor).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(AppTheme.primaryColor),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(AppTheme.secondaryColor),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(AppTheme.accentColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
