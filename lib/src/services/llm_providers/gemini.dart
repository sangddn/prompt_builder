// ignore_for_file: avoid_dynamic_calls

part of 'llm_providers.dart';

final class Gemini extends LLMProvider {
  factory Gemini({String? apiKey}) =>
      apiKey != null ? Gemini._(apiKey: apiKey) : instance;
  const Gemini._({super.apiKey});

  static const instance = Gemini._();
  static const _defaultModelsList = [
    'gemini-2.0-flash-exp',
    'gemini-1.5-flash',
    'gemini-1.5-pro',
    'gemini-1.5-flash-8b',
    'gemini-1.0-pro',
  ];

  @override
  String get defaultModel => 'gemini-1.5-flash';

  @override
  String get apiKeyKey => 'gemini_api_key';

  @override
  Future<List<String>> listModels() async {
    try {
      final apiKey = getApiKey();
      final response = await http.get(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models'),
        headers: {
          'x-goog-api-key': apiKey,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to list models: ${response.body}');
      }

      final data = jsonDecode(response.body);
      return (data['models'] as List)
          .map((model) => model['baseModelId'] as String)
          .toList();
    } on Exception catch (e) {
      debugPrint(
        'Failed to list Gemini models: $e. Using default models list.',
      );
      return _defaultModelsList;
    }
  }

  @override
  Future<(int, String)> _countTokens(String text, [String? model]) async {
    final apiKey = getApiKey();

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'
          '${model ?? defaultModel}:countTokens'),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': text},
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to count tokens: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return (
      data['totalTokens'] as int,
      'Gemini API • ${model ?? defaultModel}'
    );
  }

  @override
  Future<String> summarize(
    String content, [
    String? summarizationPrompt,
    String? model,
  ]) async {
    final apiKey = getApiKey();
    final prompt =
        (summarizationPrompt ?? ModelPreferences.getSummarizationPrompt())
            .replaceAll('{{CONTENT}}', content);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/'
          '${model ?? defaultModel}/generateContent'),
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

    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  @override
  Future<String> captionImage(
    Uint8List image, [
    String mimeType = 'image/jpeg',
    String? captionPrompt,
    String? model,
  ]) async {
    final prompt = captionPrompt ?? ModelPreferences.getImageCaptionPrompt();
    final apiKey = getApiKey();
    final base64Image = base64Encode(image);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/'
          '${model ?? defaultModel}/generateContent'),
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
                  'mime_type': mimeType,
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

    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  @override
  Future<String> generatePrompt(
    String instructions, [
    String? metaPrompt,
    String? model,
  ]) async {
    final apiKey = getApiKey();
    final prompt = (metaPrompt ?? ModelPreferences.getPromptGenerationPrompt())
        .replaceAll('{{INSTRUCTIONS}}', instructions);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/'
          '${model ?? defaultModel}/generateContent'),
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

    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  @override
  Future<String> transcribeAudio(
    Uint8List audio, [
    String mimeType = 'audio/wav',
    String? model,
  ]) async {
    final apiKey = getApiKey();

    // Convert audio to base64
    final base64Audio = base64Encode(audio);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/'
          '${model ?? defaultModel}/generateContent'),
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
                  'mime_type': mimeType,
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

    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  /// Counts the number of tokens in a given data.
  ///
  /// Based on Google's [documentation](https://ai.google.dev/gemini-api/docs/tokens).
  @override
  Future<int> countTokensFromData(
    Uint8List data,
    String mimeType, [
    String? model,
  ]) async {
    if (mimeType.startsWith('image/')) {
      return 258;
    }
    final apiKey = getApiKey();
    final base64Data = base64Encode(data);

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'
          '${model ?? defaultModel}:countTokens'),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Data,
                },
              },
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to count tokens from data: ${response.body}');
    }

    final responseData = jsonDecode(response.body);
    return responseData['totalTokens'] as int;
  }
}
