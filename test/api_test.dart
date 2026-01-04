import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_face_future/core/config/app_config.dart';
import 'package:flutter_face_future/data/datasources/gemini_remote_datasource.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  test('Gemini API Integration Test', () async {
    // 1. Load .env
    // Note: In test environment, we might need to specify path relative to test root
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      // If .env is not found (e.g. running from differnt dir), try absolute or relative path
      // This part depends on where 'flutter test' is run.
      // Assuming .env is in project root.
    }

    // Check if API Key is loaded
    final apiKey = AppConfig.geminiApiKey;
    print(
      '🔑 Loaded API Key: ${apiKey.isEmpty ? "EMPTY" : "${apiKey.substring(0, 5)}..."}',
    );

    if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY') {
      fail('API Key is not set in .env file.');
    }

    // 2. Create a dummy image file (1x1 transparent pixel is not enough, needs to be valid image)
    // We will create a minimal valid JPEG
    final List<int> minimalJpeg = [
      0xFF,
      0xD8,
      0xFF,
      0xE0,
      0x00,
      0x10,
      0x4A,
      0x46,
      0x49,
      0x46,
      0x00,
      0x01,
      0x01,
      0x01,
      0x00,
      0x48,
      0x00,
      0x48,
      0x00,
      0x00,
      0xFF,
      0xDB,
      0x00,
      0x43,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xC0,
      0x00,
      0x0B,
      0x08,
      0x00,
      0x01,
      0x00,
      0x01,
      0x01,
      0x01,
      0x11,
      0x00,
      0xFF,
      0xC4,
      0x00,
      0x1F,
      0x00,
      0x00,
      0x01,
      0x05,
      0x01,
      0x01,
      0x01,
      0x01,
      0x01,
      0x01,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x01,
      0x02,
      0x03,
      0x04,
      0x05,
      0x06,
      0x07,
      0x08,
      0x09,
      0x0A,
      0x0B,
      0xFF,
      0xC4,
      0x00,
      0xB5,
      0x10,
      0x00,
      0x02,
      0x01,
      0x03,
      0x03,
      0x02,
      0x04,
      0x03,
      0x05,
      0x05,
      0x04,
      0x04,
      0x00,
      0x00,
      0x01,
      0x7D,
      0x01,
      0x02,
      0x03,
      0x00,
      0x04,
      0x11,
      0x05,
      0x12,
      0x21,
      0x31,
      0x41,
      0x06,
      0x13,
      0x51,
      0x61,
      0x07,
      0x22,
      0x71,
      0x14,
      0x32,
      0x81,
      0x91,
      0xA1,
      0x08,
      0x23,
      0x42,
      0xB1,
      0xC1,
      0x15,
      0x52,
      0xD1,
      0xF0,
      0x24,
      0x33,
      0x62,
      0x72,
      0x82,
      0x09,
      0x0A,
      0x16,
      0x17,
      0x18,
      0x19,
      0x1A,
      0x25,
      0x26,
      0x27,
      0x28,
      0x29,
      0x2A,
      0x34,
      0x35,
      0x36,
      0x37,
      0x38,
      0x39,
      0x3A,
      0x43,
      0x44,
      0x45,
      0x46,
      0x47,
      0x48,
      0x49,
      0x4A,
      0x53,
      0x54,
      0x55,
      0x56,
      0x57,
      0x58,
      0x59,
      0x5A,
      0x63,
      0x64,
      0x65,
      0x66,
      0x67,
      0x68,
      0x69,
      0x6A,
      0x73,
      0x74,
      0x75,
      0x76,
      0x77,
      0x78,
      0x79,
      0x7A,
      0x83,
      0x84,
      0x85,
      0x86,
      0x87,
      0x88,
      0x89,
      0x8A,
      0x92,
      0x93,
      0x94,
      0x95,
      0x96,
      0x97,
      0x98,
      0x99,
      0x9A,
      0xA2,
      0xA3,
      0xA4,
      0xA5,
      0xA6,
      0xA7,
      0xA8,
      0xA9,
      0xAA,
      0xB2,
      0xB3,
      0xB4,
      0xB5,
      0xB6,
      0xB7,
      0xB8,
      0xB9,
      0xBA,
      0xC2,
      0xC3,
      0xC4,
      0xC5,
      0xC6,
      0xC7,
      0xC8,
      0xC9,
      0xCA,
      0xD2,
      0xD3,
      0xD4,
      0xD5,
      0xD6,
      0xD7,
      0xD8,
      0xD9,
      0xDA,
      0xE1,
      0xE2,
      0xE3,
      0xE4,
      0xE5,
      0xE6,
      0xE7,
      0xE8,
      0xE9,
      0xEA,
      0xF1,
      0xF2,
      0xF3,
      0xF4,
      0xF5,
      0xF6,
      0xF7,
      0xF8,
      0xF9,
      0xFA,
      0xFF,
      0xDA,
      0x00,
      0x0C,
      0x03,
      0x01,
      0x00,
      0x02,
      0x11,
      0x03,
      0x11,
      0x00,
      0x3F,
      0x00,
      0xF9,
      0xD4,
      0xAF,
      0xFF,
      0xD9,
    ];

    final tempDir = Directory.systemTemp.createTempSync();
    final imageFile = File('${tempDir.path}/test_image.jpg');
    await imageFile.writeAsBytes(minimalJpeg);
    print('🖼 Test image created at: ${imageFile.path}');

    // 3. Verify Model Availability (Text Only)
    print('📡 Checking model availability (${AppConfig.geminiModel})...');
    final model = GenerativeModel(model: AppConfig.geminiModel, apiKey: apiKey);
    try {
      final response = await model.generateContent([Content.text('Hello')]);
      print(
        'white_check_mark Model is reachable! Response: ${response.text?.substring(0, 10)}...',
      );
    } catch (e) {
      print('x Model check failed: $e');
      // If text fails, likely the model ID is wrong
      fail('Model ${AppConfig.geminiModel} not available: $e');
    }

    // 4. Call Gemini API with Image
    print('📡 Sending image request to Gemini API...');

    final dataSource = GeminiRemoteDataSource(
      apiKey: AppConfig.geminiApiKey,
      modelName: AppConfig.geminiModel,
    );
    dataSource.initialize();

    try {
      final result = await dataSource.analyzeImage(
        imageFile,
        seriousMode: false,
      );

      print('white_check_mark API Call Successful!');
      print('-----------------------------------');
      print('🏆 Job: ${result.job}');
      print('💰 Salary: ${result.salary}');
      print('📝 Comment: ${result.comment}');
      print('-----------------------------------');

      expect(result.job, isNotEmpty);
      expect(result.salary, isNotEmpty);
    } catch (e) {
      print('x API Call Failed: $e');
      fail('API call failed with error: $e');
    } finally {
      // Cleanup
      await imageFile.delete();
      tempDir.delete();
    }
  }); // timeout: const Timeout(Duration(seconds: 30))
}
