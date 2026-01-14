import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_theme.dart';
import 'home_screen.dart';

/// 온보딩 화면
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      icon: Icons.face,
      title: '얼굴 분석',
      description: 'AI가 당신의 얼굴을 분석하여\n어울리는 직업을 추천해드려요',
      color: const Color(AppTheme.primaryColor),
    ),
    OnboardingItem(
      icon: Icons.work_outline,
      title: '미래 직업 추천',
      description: '진지 모드와 재미 모드로\n다양한 직업을 만나보세요',
      color: const Color(0xFF9B59B6),
    ),
    OnboardingItem(
      icon: Icons.bar_chart,
      title: '능력치 분석',
      description: '창의력, 분석력, 리더십 등\n당신의 숨겨진 능력을 확인하세요',
      color: const Color(0xFF27AE60),
    ),
    OnboardingItem(
      icon: Icons.history,
      title: '히스토리 저장',
      description: '분석 결과를 저장하고\n언제든 다시 확인할 수 있어요',
      color: const Color(0xFFE67E22),
    ),
  ];

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground(context),
        child: SafeArea(
          child: Column(
            children: [
              // Skip 버튼
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    '건너뛰기',
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ),
              ),

              // 페이지 뷰
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_items[index], isDark);
                  },
                ),
              ),

              // 인디케이터
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _items.length,
                  (index) => _buildDot(index, isDark),
                ),
              ),
              const SizedBox(height: 32),

              // 다음/시작 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _items[_currentPage].color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _currentPage == _items.length - 1 ? '시작하기' : '다음',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 60, color: item.color),
          ),
          const SizedBox(height: 48),

          // 제목
          Text(
            item.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : const Color(AppTheme.lightTextColor),
            ),
          ),
          const SizedBox(height: 16),

          // 설명
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: isDark
                  ? Colors.white70
                  : const Color(AppTheme.lightSubTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, bool isDark) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? _items[_currentPage].color
            : (isDark ? Colors.white24 : Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// 온보딩 아이템 모델
class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
