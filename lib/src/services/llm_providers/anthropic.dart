part of 'llm_providers.dart';

final class Anthropic extends LLMProvider {
  factory Anthropic() => instance;
  const Anthropic._();

  static const apiKeyKey = 'anthropic_api_key';
  static const instance = Anthropic._();

  String _getApiKey() {
    final apiKey = Database().stringRef.get(apiKeyKey);
    if (apiKey == null) {
      throw Exception('Anthropic API key not found');
    }
    return apiKey;
  }

  @override
  Future<String> captionImage(
    Uint8List image, [
    String? captionPrompt,
    String? model = 'claude-3-5-sonnet-20241022',
  ]) async {
    final prompt = captionPrompt ?? _getImageCaptionPrompt();

    // Convert image to base64
    final base64Image = base64Encode(image);

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'x-api-key': _getApiKey(),
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? 'claude-3-5-sonnet-20241022',
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': 'image/jpeg',
                  'data': base64Image,
                },
              },
            ],
          },
        ],
        'max_tokens': 300,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to caption image: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    return data['content'][0]['text'] as String;
  }

  @override
  int countTokens(String text, [String? model]) {
    // Anthropic uses the same tokenizer as GPT-4
    final tiktoken = Tiktoken(OpenAiModel.gpt_4);
    return tiktoken.count(text);
  }

  @override
  Future<String> generatePrompt(
    String instructions, [
    String? metaPrompt,
    String? model = 'claude-3-5-sonnet-20241022',
  ]) async {
    final prompt = (metaPrompt ?? _getPromptGenerationPrompt())
        .replaceAll('{{INSTRUCTIONS}}', instructions);

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'x-api-key': _getApiKey(),
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? 'claude-3-5-sonnet-20241022',
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
    return data['content'][0]['text'] as String;
  }

  @override
  Future<String> summarize(
    String content, [
    String? summarizationPrompt,
    String? model = 'claude-3-5-sonnet-20241022',
  ]) async {
    final prompt = (summarizationPrompt ?? _getSummarizationPrompt())
        .replaceAll('{{CONTENT}}', content);

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'x-api-key': _getApiKey(),
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? 'claude-3-5-sonnet-20241022',
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
    return data['content'][0]['text'] as String;
  }

  @override
  Future<String> transcribeAudio(Uint8List audio, [String? model]) {
    throw UnimplementedError(
      'Anthropic does not currently support audio transcription',
    );
  }
}
