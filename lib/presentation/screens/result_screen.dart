import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/app_theme.dart';
import '../../domain/entities/analysis_result_entity.dart';
import '../../data/datasources/local_storage_datasource.dart';
import 'home_screen.dart';

/// 분석 결과 화면
class ResultScreen extends StatefulWidget {
  final AnalysisResultEntity result;
  final bool isSeriousMode;

  const ResultScreen({
    super.key,
    required this.result,
    required this.isSeriousMode,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  final LocalStorageDataSource _storageDataSource = LocalStorageDataSource();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final GlobalKey _resultCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveResult() async {
    final resultCard = _buildResultCardForSave();
    final success = await _storageDataSource.captureAndSaveToGallery(
      resultCard,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                success ? '결과가 저장되었습니다!' : '저장에 실패했습니다',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          backgroundColor: success
              ? const Color(AppTheme.primaryColor)
              : const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );

      // 저장 후 홈으로 이동
      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _openCareerNet() async {
    final uri = Uri.parse('https://www.career.go.kr/cnet/front/main/main.do');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 결과 카드
                    RepaintBoundary(
                      key: _resultCardKey,
                      child: _buildResultCard(),
                    ),
                    const SizedBox(height: 24),
                    // AI 분석 근거
                    _buildFeaturesCard(),
                    const SizedBox(height: 16),
                    // 능력치 차트
                    _buildStatsCard(),
                    const SizedBox(height: 32),
                    // 직업 정보 (모든 모드에서 표시)
                    _buildJobInfoCard(),
                    const SizedBox(height: 24),
                    // 액션 버튼들
                    _buildActionButtons(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 타이틀
          const Text(
            '🔮 당신의 미래 직업',
            style: TextStyle(
              fontSize: 14,
              color: Color(AppTheme.accentColor),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // 직업명
          Text(
            widget.result.job,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(AppTheme.secondaryColor),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
            // maxLines: 2, // Removed max lines to prevent cutting off
            // overflow: TextOverflow.ellipsis, // Removed ellipsis
          ),
          const SizedBox(height: 16),
          // 연봉
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(AppTheme.backgroundColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '💰 예상 연봉: ${widget.result.salary}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(AppTheme.primaryColor),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          // 한줄 코멘트
          Text(
            '"${widget.result.comment}"',
            style: const TextStyle(
              fontSize: 16,
              color: Color(AppTheme.secondaryColor),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCardForSave() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 400,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E), // Deep navy
              Color(0xFF16213E), // Dark blue
              Color(0xFF0F0F23), // Near black
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Branding Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🔮', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text(
                    'Face Future',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Result Card Content
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(AppTheme.primaryColor).withOpacity(0.3),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Job Title
                  const Text(
                    '당신의 미래 직업',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(AppTheme.accentColor),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.result.job,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Salary Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(AppTheme.primaryColor).withOpacity(0.8),
                          const Color(AppTheme.primaryColor).withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '💰 ${widget.result.salary}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Comment
                  Text(
                    '"${widget.result.comment}"',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Footer
            Text(
              'AI 관상 분석 by Face Future',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      decoration: AppTheme
          .cardDecoration, // Using card decoration instead of glassmorphism
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: Color(AppTheme.primaryColor)),
              SizedBox(width: 8),
              Text(
                'AI가 분석한 당신의 특징',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(AppTheme.secondaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildFeatureItem('👁️ 눈매', widget.result.features.eyes),
          _buildFeatureItem('👃 코', widget.result.features.nose),
          _buildFeatureItem('👄 입', widget.result.features.mouth),
          _buildFeatureItem('✨ 분위기', widget.result.features.vibe),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(AppTheme.accentColor),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(AppTheme.secondaryColor),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final stats = widget.result.stats;
    final statLabels = ['창의력', '분석력', '리더십', '소통력', '체력', '운'];
    final statValues = stats.toList();

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.radar, color: Color(AppTheme.primaryColor)),
              SizedBox(width: 8),
              Text(
                '능력치 분석',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(AppTheme.secondaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 300, // Increased height for better fit
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                radarBorderData: const BorderSide(
                  color: Color(AppTheme.accentColor),
                  width: 1,
                ),
                gridBorderData: const BorderSide(
                  color: Color(0xFF2C2C2C), // Dark grey for grid in Black Theme
                  width: 1,
                ),
                tickBorderData: const BorderSide(color: Colors.transparent),
                tickCount: 4,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                titleTextStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(AppTheme.secondaryColor),
                  fontWeight: FontWeight.w600,
                ),
                getTitle: (index, angle) {
                  // Adjusting margin for labels to prevent overflow (simplistic approach via padding in label if needed, but increased height helps)
                  return RadarChartTitle(
                    text: '${statLabels[index]}\n${statValues[index].toInt()}',
                    positionPercentageOffset:
                        0.15, // Increase this value to push labels out further or adjust as needed, but if overflow is issue, maybe 0.1 or reduce it. Actually, if it's outside container, we need more padding in container NOT pushing it out more.
                    // Wait, if it's "outside the container", it means the chart is too big. We should reduce radius or increase container padding.
                    // Let's try to keep titles closer (default is 0.2? maybe 0.1) or allow Chart to be smaller.
                    // Better approach: Reduce chart radius manually if possible?
                    // Actually, just increasing padding or using a smaller radius factor.
                  );
                },
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color(AppTheme.primaryColor).withOpacity(
                      0.2,
                    ), // Fixed withValues to withOpacity for consistency
                    borderColor: const Color(AppTheme.primaryColor),
                    borderWidth: 2,
                    entryRadius: 4,
                    dataEntries: statValues
                        .map((v) => RadarEntry(value: v))
                        .toList(),
                  ),
                ],
                radarTouchData: RadarTouchData(
                  enabled: false,
                ), // Disable touch to prevent potential issues
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobInfoCard() {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.work, color: Color(AppTheme.primaryColor)),
              SizedBox(width: 8),
              Text(
                '직업 상세 정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(AppTheme.secondaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 설명
          Text(
            widget.result.jobInfo.description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(AppTheme.secondaryColor),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // 필요 역량
          const Text(
            '📌 필요 역량',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(AppTheme.secondaryColor),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.result.jobInfo.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(AppTheme.backgroundColor),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppTheme.secondaryColor),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // 관련 학과
          const Text(
            '🎓 관련 학과',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(AppTheme.secondaryColor),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.result.jobInfo.departments.map((dept) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(
                    AppTheme.primaryColor,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dept,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppTheme.primaryColor),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // 커리어넷 링크
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _openCareerNet,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(AppTheme.backgroundColor),
                foregroundColor: const Color(AppTheme.secondaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '커리어넷에서 더 알아보기',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _saveResult,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(AppTheme.primaryColor),
                  elevation: 0,
                ),
                child: const Text(
                  '결과 저장',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppTheme.backgroundColor),
                  foregroundColor: const Color(AppTheme.secondaryColor),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(color: Colors.white12),
                ),
                child: const Text(
                  '다시 하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
