import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/config/app_theme.dart';
import '../../core/di/injection_container.dart';
import '../../data/datasources/gemini_remote_datasource.dart';
import '../../domain/usecases/analyze_face_usecase.dart';
import 'result_screen.dart';
import 'home_screen.dart';

/// AI 분석 로딩 화면
class LoadingScreen extends StatefulWidget {
  final File imageFile;
  final bool isSeriousMode;

  const LoadingScreen({
    super.key,
    required this.imageFile,
    required this.isSeriousMode,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  final AnalyzeFaceUseCase _analyzeFaceUseCase = di.analyzeFaceUseCase;

  late AnimationController _animationController;
  late List<int> _matrixStream;
  final Random _random = Random();

  int _currentStep = 0;
  final List<String> _steps = [
    '얼굴 데이터 추출 중...',
    'AI 특징 분석 중...',
    '빅데이터 매칭 중...',
    '미래 직업 예측 중...',
  ];

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _matrixStream = List.generate(20, (index) => _random.nextInt(100));
    _startAnalysis();
    _stepTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _stepTimer() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        setState(() => _currentStep = i);
      }
    }
  }

  Future<void> _deleteImageFile() async {
    try {
      if (await widget.imageFile.exists()) {
        await widget.imageFile.delete();
        debugPrint('✅ 이미지가 안전하게 삭제되었습니다.');
      }
    } catch (e) {
      debugPrint('파일 삭제 실패: $e');
    }
  }

  Future<void> _startAnalysis() async {
    try {
      // UseCase로 분석 실행 (얼굴 검증 + 분석 포함)
      final result = await _analyzeFaceUseCase.execute(
        widget.imageFile,
        seriousMode: widget.isSeriousMode,
      );

      // 분석 완료 후 이미지 삭제 (보안)
      await _deleteImageFile();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ResultScreen(
                  result: result,
                  isSeriousMode: widget.isSeriousMode,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } on FaceValidationException catch (e) {
      await _deleteImageFile();
      if (mounted) {
        setState(() {
          _errorMessage = '${e.message}\n얼굴이 잘 보이는 사진으로 다시 시도해주세요!';
        });
      }
    } on NetworkException catch (e) {
      await _deleteImageFile();
      if (mounted) {
        setState(() {
          _errorMessage = '${e.message}\n와이파이 또는 데이터 연결을 확인해주세요.';
        });
      }
    } on ServerException catch (e) {
      await _deleteImageFile();
      if (mounted) {
        setState(() {
          _errorMessage = '${e.message}\n잠시 후 다시 시도해주세요.';
        });
      }
    } on ParsingException catch (e) {
      await _deleteImageFile();
      if (mounted) {
        setState(() {
          _errorMessage = '${e.message}\n다시 시도해주세요.';
        });
      }
    } catch (e) {
      await _deleteImageFile();
      if (mounted) {
        setState(() {
          _errorMessage = '알 수 없는 오류가 발생했습니다.\n$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Matrix effect looks best on black
      body: Stack(
        children: [
          // Matrix Rain Effect
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MatrixPainter(
                    animationValue: _animationController.value,
                    stream: _matrixStream,
                  ),
                );
              },
            ),
          ),

          // Content Overlay
          SafeArea(
            child: _errorMessage != null
                ? _buildErrorView()
                : _buildLoadingView(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // No CircularProgressIndicator here as requested
        const SizedBox(height: 32),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _steps[_currentStep],
              key: ValueKey(_currentStep),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(AppTheme.primaryColor), // Using Blue for text
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Color(AppTheme.primaryColor),
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(AppTheme.errorColor),
            ),
            const SizedBox(height: 24),
            const Text(
              '오류 발생',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppTheme.primaryColor),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('처음으로'),
            ),
          ],
        ),
      ),
    );
  }
}

class MatrixPainter extends CustomPainter {
  final double animationValue;
  final List<int> stream;

  MatrixPainter({required this.animationValue, required this.stream});

  @override
  void paint(Canvas canvas, Size size) {
    final double fontSize = 14;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < stream.length; i++) {
      // Simple falling effect
      double y = (stream[i] * 10 + animationValue * 500) % size.height;
      double x = i * size.width / stream.length;

      // Draw random characters
      String char = String.fromCharCode(
        0x30A0 + (y.toInt() % 96),
      ); // Katakana characters often used for matrix

      textPainter.text = TextSpan(
        text: char,
        style: TextStyle(
          color: const Color(
            AppTheme.primaryColor,
          ).withValues(alpha: (y / size.height)),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant MatrixPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
