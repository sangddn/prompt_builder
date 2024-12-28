import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_builder/src/services/llm_providers/llm_providers.dart';

import 'test_utils.dart';

void main() {
  late Anthropic anthropic;

  setUpAll(() async {
    await loadTestEnv();
    anthropic = Anthropic(apiKey: dotenv.env['ANTHROPIC_API_KEY']);
  });

  group('Anthropic Provider', () {
    test('listModels returns valid models', () async {
      final models = await anthropic.listModels();
      verifyModelList(models);
      expect(
        models.any((m) => m.contains('claude')),
        isTrue,
        reason: 'Should contain Claude models',
      );
    });

    test('countTokens returns valid count', () async {
      final (count, method) = await anthropic.countTokens(
        'This is a test message to count tokens.',
      );
      verifyTokenCount(count, method);
      expect(method, contains('Anthropic API'));
    });

    test('countTokensFromData handles images', () async {
      final imageData = await getTestImage();
      final count = await anthropic.countTokensFromData(
        imageData,
        'image/jpeg',
      );
      expect(count, greaterThan(0));
    });

    test('summarize generates valid summary', () async {
      final summary = await anthropic.summarize(
        'This is a long text that needs to be summarized. It contains multiple '
        'sentences and ideas that should be condensed into a shorter form while '
        'maintaining the key points and meaning of the original text.',
      );
      verifyGeneratedText(summary);
    });

    test('captionImage generates valid caption', () async {
      final imageData = await getTestImage();
      final caption = await anthropic.captionImage(imageData);
      verifyGeneratedText(caption);
    });

    test('generatePrompt creates valid prompt', () async {
      final prompt = await anthropic.generatePrompt(
        'Create a prompt that will help generate creative story ideas',
      );
      verifyGeneratedText(prompt);
    });

    test('transcribeAudio throws UnsupportedError', () {
      expect(
        () => anthropic.transcribeAudio(Uint8List(0)),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
