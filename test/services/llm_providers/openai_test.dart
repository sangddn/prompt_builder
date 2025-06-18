import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_builder/src/services/llm_providers/llm_providers.dart';

import 'test_utils.dart';

void main() {
  late OpenAI openai;

  setUpAll(() async {
    await loadTestEnv();
    openai = OpenAI(apiKey: dotenv.env['OPENAI_API_KEY']);
  });

  group('OpenAI Provider', () {
    test('listModels returns valid models', () async {
      final models = await openai.listModels();
      verifyModelList(models);
      expect(
        models.any((m) => m.contains('gpt')),
        isTrue,
        reason: 'Should contain GPT models',
      );
    });

    test('countTokens returns valid count', () async {
      final (count, method) = await openai.countTokens(
        'This is a test message to count tokens.',
      );
      verifyTokenCount(count, method);
    });

    test('countTokensFromData handles images', () async {
      final imageData = await getTestImage();
      final count = await openai.countTokensFromData(imageData, 'image/jpeg');
      expect(count, greaterThan(0));
    });

    test('summarize generates valid summary', () async {
      final summary = await openai.summarize(
        'This is a long text that needs to be summarized. It contains multiple '
        'sentences and ideas that should be condensed into a shorter form while '
        'maintaining the key points and meaning of the original text.',
      );
      verifyGeneratedText(summary);
    });

    test('captionImage generates valid caption', () async {
      final imageData = await getTestImage();
      final caption = await openai.captionImage(imageData);
      verifyGeneratedText(caption);
    });

    test('generatePrompt creates valid prompt', () async {
      final prompt = await openai.generatePrompt(
        'Create a prompt that will help generate creative story ideas',
      );
      verifyGeneratedText(prompt);
    });

    test('transcribeAudio generates valid transcription', () async {
      final audioData = await getTestAudio();
      final transcription = await openai.transcribeAudio(audioData);
      verifyGeneratedText(transcription);
    });
  });
}
