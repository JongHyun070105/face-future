import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

/// 이미지 저장 서비스
class StorageService {
  final ScreenshotController screenshotController = ScreenshotController();

  /// 위젯을 캡처해서 갤러리에 저장
  Future<bool> captureAndSaveToGallery(Widget widget) async {
    try {
      final Uint8List imageBytes = await screenshotController.captureFromWidget(
        widget,
        delay: const Duration(milliseconds: 100),
      );

      final result = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: 100,
        name: 'face_future_${DateTime.now().millisecondsSinceEpoch}',
      );

      return result['isSuccess'] ?? false;
    } catch (e) {
      debugPrint('이미지 저장 실패: $e');
      return false;
    }
  }

  /// 임시 폴더에 이미지 저장
  Future<File> saveToTemp(Uint8List imageBytes, String fileName) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return file;
  }

  /// 임시 파일 삭제
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        debugPrint('✅ 이미지가 안전하게 삭제되었습니다.');
      }
    } catch (e) {
      debugPrint('파일 삭제 실패: $e');
    }
  }
}
