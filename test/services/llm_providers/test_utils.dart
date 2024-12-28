import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads environment variables from .env file
Future<void> loadTestEnv() async {
  await dotenv.load();
}

/// Gets test image data
Future<Uint8List> getTestImage() async {
  final file = File('test/assets/test_image.jpg');
  return file.readAsBytes();
}

/// Gets test audio data
Future<Uint8List> getTestAudio() async {
  final file = File('test/assets/test_audio.wav');
  return file.readAsBytes();
}

/// Verifies that a model list is not empty and contains expected format
void verifyModelList(List<String> models) {
  expect(models, isNotEmpty);
  for (final model in models) {
    expect(model, isA<String>());
    expect(model.isEmpty, isFalse);
  }
}

/// Verifies that a token count result is valid
void verifyTokenCount(int count, String method) {
  expect(count, greaterThan(0));
  expect(method, isNotEmpty);
}

/// Verifies that generated text is valid
void verifyGeneratedText(String text) {
  expect(text, isNotEmpty);
  expect(
    text.trim(),
    equals(text),
    reason: 'Text should not have leading/trailing whitespace',
  );
}
