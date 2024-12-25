part of 'llm_providers.dart';

final class OpenAI extends LLMProvider {
  factory OpenAI() => instance;
  const OpenAI._();

  static const apiKeyKey = 'openai_api_key';
  static const instance = OpenAI._();

  String _getApiKey() {
    final apiKey = Database().stringRef.get(apiKeyKey);
    if (apiKey == null) {
      throw Exception('OpenAI API key not found');
    }
    return apiKey;
  }

  @override
  Future<String> captionImage(
    Uint8List image, [
    String? captionPrompt,
    String? model = 'gpt-4o',
  ]) async {
    final prompt = captionPrompt ?? _getImageCaptionPrompt();
    final apiKey = _getApiKey();

    // Convert image to base64
    final base64Image = base64Encode(image);

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? 'gpt-4o',
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
              }
            ],
          }
        ],
        'max_tokens': 300,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to caption image: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    return data['choices'][0]['message']['content'] as String;
  }

  @override
  int countTokens(String text, [String? model]) {
    final tiktoken = switch (model) {
      'gpt-4o-mini' => Tiktoken(OpenAiModel.gpt_4o_mini),
      'gpt-4o' => Tiktoken(OpenAiModel.gpt_4o),
      'gpt-4' => Tiktoken(OpenAiModel.gpt_4),
      'o1' => Tiktoken(OpenAiModel.o1),
      'o1-mini' => Tiktoken(OpenAiModel.o1_mini),
      _ => Tiktoken(OpenAiModel.gpt_4o),
    };
    return tiktoken.count(text);
  }

  @override
  Future<String> generatePrompt(
    String instructions, [
    String? metaPrompt,
    String? model = 'gpt-4o',
  ]) async {
    final apiKey = _getApiKey();
    final prompt = (metaPrompt ?? _getPromptGenerationPrompt())
        .replaceAll('{{INSTRUCTIONS}}', instructions);

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? 'gpt-4o',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to generate prompt: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    return data['choices'][0]['message']['content'] as String;
  }

  @override
  Future<String> summarize(
    String content, [
    String? summarizationPrompt,
    String? model = 'gpt-4o',
  ]) async {
    final apiKey = _getApiKey();
    final prompt = (summarizationPrompt ?? _getSummarizationPrompt())
        .replaceAll('{{CONTENT}}', content);

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? 'gpt-4o',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to summarize content: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    return data['choices'][0]['message']['content'] as String;
  }

  @override
  Future<String> transcribeAudio(
    Uint8List audio, [
    String? model = 'whisper-1',
  ]) async {
    final apiKey = _getApiKey();

    // Create multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
    );

    request.headers['Authorization'] = 'Bearer $apiKey';
    request.fields['model'] = model ?? 'whisper-1';
    request.files.add(http.MultipartFile.fromBytes('file', audio));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Failed to transcribe audio: $responseBody');
    }

    final data = jsonDecode(responseBody);
    // ignore: avoid_dynamic_calls
    return data['text'] as String;
  }
}
