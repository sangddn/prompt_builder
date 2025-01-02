// ignore_for_file: avoid_dynamic_calls, use_late_for_private_fields_and_variables

part of 'llm_providers.dart';

List<String>? _cachedAnthropicModelNames;

final class Anthropic extends LLMProvider {
  factory Anthropic({String? apiKey}) =>
      apiKey != null ? Anthropic._(apiKey: apiKey) : instance;
  const Anthropic._({super.apiKey});

  static const instance = Anthropic._();
  static const _defaultModelsList = [
    'claude-3-5-sonnet-latest',
    'claude-3-5-sonnet-20241022',
    'claude-3-5-sonnet-20240620',
    'claude-3-5-haiku-latest',
    'claude-3-5-haiku-20241022',
    'claude-3-opus-20240229',
    'claude-3-sonnet-20240229',
    'claude-3-haiku-20240307',
  ];

  @override
  String get defaultModel => 'claude-3-5-sonnet-latest';

  @override
  String get apiKeyKey => 'anthropic_api_key';

  static const _defaultMaxTokens = 3000;

  Map<String, String> _getHeaders() => {
        'x-api-key': getApiKey(),
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      };

  @override
  Future<List<String>> listModels() async {
    if (_cachedAnthropicModelNames != null) return _cachedAnthropicModelNames!;
    try {
      final response = await http.get(
        Uri.parse('https://api.anthropic.com/v1/models'),
        headers: _getHeaders()..remove('Content-Type'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        final error = data['error']['message'] as String;
        debugPrint('Anthropic error: $error');
        throw Exception(error);
      }

      return _cachedAnthropicModelNames ??=
          (data['data'] as List).map((model) => model['id'] as String).toList();
    } on Exception catch (e) {
      debugPrint('Failed to list models: $e. Using default models list.');
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

    // Convert image to base64
    final base64Image = base64Encode(image);

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: _getHeaders(),
      body: jsonEncode({
        'model': model ?? defaultModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': mimeType,
                  'data': base64Image,
                },
              },
            ],
          },
        ],
        'max_tokens': _defaultMaxTokens,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Anthropic error: $error');
      throw Exception(error);
    }

    return data['content'][0]['text'] as String;
  }

  /// Counts the number of tokens in a text string using Anthropic's token counting API.
  ///
  /// This method is useful for estimating costs and ensuring text fits within model
  /// context limits before making API calls.
  ///
  /// Parameters:
  /// - [text] The text content to count tokens for
  /// - [model] Optional model identifier. Defaults to [_defaultModel]
  ///
  /// Returns the number of tokens in the text.
  ///
  /// Throws:
  /// - [Exception] if the API request fails
  @override
  Future<(int, String)> _countTokens(String text, [String? model]) async {
    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages/count_tokens'),
      headers: _getHeaders(),
      body: jsonEncode({
        'model': model ?? defaultModel,
        'messages': [
          {'role': 'user', 'content': text},
        ],
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Anthropic error: $error');
      throw Exception(error);
    }

    return (
      data['input_tokens'] as int,
      'Anthropic API • ${model ?? defaultModel}'
    );
  }

  /// Counts tokens for binary data (images or PDFs) using Anthropic's token counting API.
  ///
  /// Supports:
  /// - Images (JPEG, PNG, GIF, WEBP)
  /// - PDFs (requires beta feature flag)
  ///
  /// Parameters:
  /// - [data] The binary content as [Uint8List]
  /// - [mimeType] The MIME type of the content (e.g., 'image/jpeg', 'application/pdf')
  /// - [model] Optional model identifier. Defaults to [_defaultModel]
  ///
  /// Returns the number of tokens the binary data will consume.
  ///
  /// Throws:
  /// - [UnsupportedError] for unsupported mime types (video/audio)
  /// - [Exception] if the API request fails
  @override
  Future<int> countTokensFromData(
    Uint8List data,
    String mimeType, [
    String? model,
  ]) async {
    if (!mimeType.startsWith('image/') &&
        !mimeType.startsWith('application/pdf')) {
      throw UnsupportedError(
        'Anthropic does not support token counting for $mimeType files',
      );
    }

    final base64Data = base64Encode(data);
    final contentType = mimeType.startsWith('image/') ? 'image' : 'document';

    final Map<String, dynamic> requestBody = {
      'model': model ?? defaultModel,
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': contentType,
              'source': {
                'type': 'base64',
                'media_type': mimeType,
                'data': base64Data,
              },
            },
          ],
        },
      ],
    };

    // Create mutable copy of headers and add PDF beta flag if needed
    final headers = Map<String, String>.from(_getHeaders());
    if (mimeType.startsWith('application/pdf')) {
      headers['anthropic-beta'] = 'pdfs-2024-09-25';
    }

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages/count_tokens'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = responseData['error']['message'] as String;
      debugPrint('Anthropic error: $error');
      throw Exception(error);
    }

    return responseData['input_tokens'] as int;
  }

  @override
  Future<String> generatePrompt(
    String instructions, [
    String? metaPrompt,
    String? model,
  ]) async {
    final prompt = (metaPrompt ?? ModelPreferences.getPromptGenerationPrompt())
        .replaceAll('{{INSTRUCTIONS}}', instructions);

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: _getHeaders(),
      body: jsonEncode({
        'model': model ?? defaultModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': _defaultMaxTokens,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Anthropic error: $error');
      throw Exception(error);
    }

    return data['content'][0]['text'] as String;
  }

  @override
  Future<String> summarize(
    String content, [
    String? summarizationPrompt,
    String? model,
  ]) async {
    final prompt =
        (summarizationPrompt ?? ModelPreferences.getSummarizationPrompt())
            .replaceAll('{{CONTENT}}', content);

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: _getHeaders(),
      body: jsonEncode({
        'model': model ?? defaultModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': _defaultMaxTokens,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error']['message'] as String;
      debugPrint('Anthropic error: $error');
      throw Exception(error);
    }

    return data['content'][0]['text'] as String;
  }

  @override
  Future<String> transcribeAudio(
    Uint8List audio, [
    String? mimeType,
    String? model,
  ]) {
    throw UnsupportedError(
      'Anthropic does not currently support audio transcription',
    );
  }
}
