import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_builder/src/services/llm_providers/llm_providers.dart';

import 'test_utils.dart';

void main() {
  late Gemini gemini;

  setUpAll(() async {
    await loadTestEnv();
    gemini = Gemini(apiKey: dotenv.env['GEMINI_API_KEY']);
  });

  group('Gemini Provider', () {
    test('listModels returns valid models', () async {
      final models = await gemini.listModels();
      verifyModelList(models);
      expect(
        models.any((m) => m.contains('gemini')),
        isTrue,
        reason: 'Should contain Gemini models',
      );
    });

    test('countTokens returns valid count', () async {
      final (count, method) = await gemini.countTokens(
        'This is a test message to count tokens.',
      );
      verifyTokenCount(count, method);
      expect(method, contains('Gemini API'));
    });

    test('countTokensFromData handles images', () async {
      final imageData = await getTestImage();
      final count = await gemini.countTokensFromData(imageData, 'image/jpeg');
      expect(count, equals(258));
    });

    test('summarize generates valid summary', () async {
      final summary = await gemini.summarize(
        'This is a long text that needs to be summarized. It contains multiple '
        'sentences and ideas that should be condensed into a shorter form while '
        'maintaining the key points and meaning of the original text.',
      );
      verifyGeneratedText(summary);
    });

    test('captionImage generates valid caption', () async {
      final imageData = await getTestImage();
      final caption = await gemini.captionImage(imageData);
      verifyGeneratedText(caption);
    });

    test('generatePrompt creates valid prompt', () async {
      final prompt = await gemini.generatePrompt(
        'Create a prompt that will help generate creative story ideas',
      );
      verifyGeneratedText(prompt);
    });

    test('transcribeAudio generates valid transcription', () async {
      final audioData = await getTestAudio();
      final transcription = await gemini.transcribeAudio(audioData);
      verifyGeneratedText(transcription);
    });
  });
}
