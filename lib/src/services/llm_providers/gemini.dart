part of 'llm_providers.dart';

final class Gemini extends LLMProvider {
  factory Gemini() => instance;
  const Gemini._();

  static const apiKeyKey = 'gemini_api_key';
  static const instance = Gemini._();
  static const _defaultModel = 'gemini-1.5-flash';

  String _getApiKey() {
    final apiKey = Database().stringRef.get(apiKeyKey);
    if (apiKey == null) {
      throw Exception('Gemini API key not found');
    }
    return apiKey;
  }

  @override
  int countTokens(String text, [String? model]) {
    // Gemini uses roughly the same tokenizer as GPT-3.5/4
    final tiktoken = Tiktoken(OpenAiModel.gpt_4);
    return tiktoken.count(text);
  }

  @override
  Future<String> summarize(
    String content, [
    String? summarizationPrompt,
    String? model = _defaultModel,
  ]) async {
    final apiKey = _getApiKey();
    final prompt = (summarizationPrompt ?? _getSummarizationPrompt())
        .replaceAll('{{CONTENT}}', content);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/'
          '${model ?? _defaultModel}/generateContent'),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to summarize content: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  @override
  Future<String> captionImage(
    Uint8List image, [
    String? captionPrompt,
    String? model = _defaultModel,
  ]) async {
    final prompt = captionPrompt ?? _getImageCaptionPrompt();
    final apiKey = _getApiKey();
    final base64Image = base64Encode(image);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/'
          '${model ?? _defaultModel}/generateContent'),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': base64Image,
                },
              }
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to caption image: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  @override
  Future<String> generatePrompt(
    String instructions, [
    String? metaPrompt,
    String? model = _defaultModel,
  ]) async {
    final apiKey = _getApiKey();
    final prompt = (metaPrompt ?? _getPromptGenerationPrompt())
        .replaceAll('{{INSTRUCTIONS}}', instructions);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/'
          '${model ?? _defaultModel}/generateContent'),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to generate prompt: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  @override
  Future<String> transcribeAudio(
    Uint8List audio, [
    String? model = _defaultModel,
  ]) async {
    final apiKey = _getApiKey();

    // Convert audio to base64
    final base64Audio = base64Encode(audio);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/'
          '${model ?? _defaultModel}/generateContent'),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': 'Transcribe the following audio:'},
              {
                'inline_data': {
                  'mime_type': 'audio/mp3',
                  'data': base64Audio,
                },
              },
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to transcribe audio: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }
}
