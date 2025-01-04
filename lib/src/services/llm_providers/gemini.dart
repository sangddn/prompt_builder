// ignore_for_file: avoid_dynamic_calls, use_late_for_private_fields_and_variables

part of 'llm_providers.dart';

List<String>? _cachedGeminiModelNames;

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
    if (_cachedGeminiModelNames != null) return _cachedGeminiModelNames!;
    try {
      final apiKey = getApiKey();
      final response = await http.get(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models'),
        headers: {'x-goog-api-key': apiKey},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        final error = data['error']['message'] as String;
        debugPrint('Gemini error: $error');
        throw Exception(error);
      }

      return _cachedGeminiModelNames ??= (data['models'] as List)
          .map((model) => (model['name'] as String).replaceFirst('models/', ''))
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
          '${model ?? defaultModel}:countTokens?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': text},
            ],
          }
        ],
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Gemini error: $error');
      throw Exception(error);
    }

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
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'
          '${model ?? defaultModel}:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
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

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Gemini error: $error');
      throw Exception(error);
    }

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
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'
          '${model ?? defaultModel}:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
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

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Gemini error: $error');
      throw Exception(error);
    }

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
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'
          '${model ?? defaultModel}:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
            ],
          }
        ],
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Gemini error: $error');
      throw Exception(error);
    }

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
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'
          '${model ?? defaultModel}:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'text': 'Transcribe the following audio. If possible, such as when you recognize some context around the audio, provide that contextual information. Do not include any other text in your response.',
              },
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

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Gemini error: $error. code: ${response.statusCode}');
      throw Exception(error);
    }

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
          '${model ?? defaultModel}:countTokens?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
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

    final responseData = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = responseData['error']['message'] as String;
      debugPrint('Gemini error: $error');
      throw Exception(error);
    }

    return responseData['totalTokens'] as int;
  }
}
