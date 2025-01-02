// ignore_for_file: avoid_dynamic_calls, use_late_for_private_fields_and_variables

part of 'llm_providers.dart';

List<String>? _cachedOpenAIModelNames;

final class OpenAI extends LLMProvider {
  factory OpenAI({String? apiKey}) =>
      apiKey != null ? OpenAI._(apiKey: apiKey) : instance;
  const OpenAI._({super.apiKey});

  static const instance = OpenAI._();
  static const _defaultModelsList = [
    'gpt-4o',
    'gpt-4o-2024-11-20',
    'gpt-4o-2024-08-06',
    'gpt-4o-audio-preview',
    'gpt-4o-audio-preview-2024-12-17',
    'gpt-4o-audio-preview-2024-10-01',
    'gpt-4o-2024-05-13',
    'gpt-4o-mini',
    'gpt-4o-mini-2024-07-18',
    'gpt-4o-mini-audio-preview',
    'gpt-4o-mini-audio-preview-2024-12-17',
    'o1',
    'o1-2024-12-17',
    'o1-preview',
    'o1-preview-2024-09-12',
    'o1-mini',
    'o1-mini-2024-09-12',
  ];

  @override
  String get defaultModel => 'gpt-4o';

  @override
  String get apiKeyKey => 'openai_api_key';

  @override
  Future<List<String>> listModels() async {
    if (_cachedOpenAIModelNames != null) return _cachedOpenAIModelNames!;
    try {
      final apiKey = getApiKey();
      final response = await http.get(
        Uri.parse('https://api.openai.com/v1/models'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['error']['message'] as String);
      }

      final models =
          (data['data'] as List).map((model) => model['id'] as String).toList();

      return _cachedOpenAIModelNames ??=
          (models.isEmpty ? _defaultModelsList : models);
    } on Exception catch (e) {
      debugPrint('Failed to fetch models: $e. Using default models list.');
      return _defaultModelsList;
    }
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

    // Convert image to base64
    final base64Image = base64Encode(image);

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? defaultModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image_url',
                'image_url': {'url': 'data:$mimeType;base64,$base64Image'},
              }
            ],
          }
        ],
        'max_tokens': 300,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['error']['message'] as String);
    }

    return data['choices'][0]['message']['content'] as String;
  }

  /// Counts the number of tokens in a given text.
  ///
  /// Since OpenAI doesn't have an API for this, we use the closest fallback
  /// from [Anthropic], which itself may fallback to Tiktoken.
  @override
  Future<(int, String)> _countTokens(String text, [String? model]) {
    try {
      // Make sure we only use Anthropic API if user has set a key.
      Anthropic().getApiKey();
    } on ApiKeyNotSetException {
      rethrow;
    }
    return Anthropic()._countTokens(text, model);
  }

  /// Counts the number of tokens in a given image.
  ///
  /// Based on OpenAI's [documentation](https://platform.openai.com/docs/guides/vision/count-tokens).
  @override
  Future<int> countTokensFromData(
    Uint8List data,
    String mimeType, [
    String? model,
  ]) async {
    if (mimeType.startsWith('image/')) {
      final image = await decodeImageFromList(data);
      final width = image.width;
      final height = image.height;

      // Resize logic
      var resizedWidth = width;
      var resizedHeight = height;
      if (width > 1024 || height > 1024) {
        if (width > height) {
          resizedHeight = height * 1024 ~/ width;
          resizedWidth = 1024;
        } else {
          resizedWidth = width * 1024 ~/ height;
          resizedHeight = 1024;
        }
      }

      // Calculate tokens
      final h = (resizedHeight / 512).ceil();
      final w = (resizedWidth / 512).ceil();
      final total = 85 + 170 * h * w;

      return Future.value(total);
    }

    throw UnimplementedError('OpenAI does not support tokenizing $mimeType');
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
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? defaultModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error']['message'] as String);
    }

    return data['choices'][0]['message']['content'] as String;
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
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? defaultModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error']['message'] as String);
    }

    return data['choices'][0]['message']['content'] as String;
  }

  /// Transcribes audio using OpenAI's Whisper model.
  ///
  /// This is the only audio transcription model for OpenAI. [model] is ignored.
  @override
  Future<String> transcribeAudio(
    Uint8List audio, [
    String mimeType = 'audio/wav',
    String? model,
  ]) async {
    final apiKey = getApiKey();

    // Create multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
    );

    request.headers['Authorization'] = 'Bearer $apiKey';
    request.fields['model'] = 'whisper-1';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        audio,
        filename: 'file',
        contentType: MediaType.parse(mimeType),
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);

    if (response.statusCode != 200) {
      throw Exception(data['error']['message'] as String);
    }

    return data['text'] as String;
  }
}
