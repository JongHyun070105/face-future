import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/common_widgets.dart';

/// 이미지 선택 서비스
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// 이미지 선택 (카메라 또는 갤러리)
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      return null;
    }
  }

  /// 이미지 소스 선택 다이얼로그 표시 후 이미지 반환
  Future<File?> showPickerAndGetImage(BuildContext context) async {
    File? selectedImage;

    await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ImageSourceBottomSheet(
        onCameraTap: () async {
          Navigator.pop(ctx);
          selectedImage = await pickImage(ImageSource.camera);
        },
        onGalleryTap: () async {
          Navigator.pop(ctx);
          selectedImage = await pickImage(ImageSource.gallery);
        },
      ),
    );

    return selectedImage;
  }
}
