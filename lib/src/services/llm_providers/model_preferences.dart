part of 'llm_providers.dart';

abstract final class ModelPreferences {
  static const summarizationProviderKey = 'summarization_provider';
  static const imageCaptionProviderKey = 'image_caption_provider';
  static const promptGenerationProviderKey = 'prompt_generation_provider';
  static const audioTranscriptionProviderKey = 'audio_transcription_provider';

  static const summarizationPromptKey = 'summarization_prompt';
  static const imageCaptionPromptKey = 'image_caption_prompt';
  static const promptGenerationPromptKey = 'prompt_generation_prompt';

  static const defaultSummarizationPrompt =
      r'Summarize the following text:\n\n{{CONTENT}}';
  static const defaultImageCaptionPrompt = r'Describe the following image.';
  static const defaultPromptGenerationPrompt =
      r'Generate a prompt for an LLM based on the following user instruction:\n\n{{INSTRUCTIONS}}';

  static (LLMProvider, String)? _getProvider(String key) {
    final providerModel = Database().stringRef.get(key);
    if (providerModel == null) {
      try {
        OpenAI().getApiKey();
        return (OpenAI(), OpenAI().defaultModel);
      } on ApiKeyNotSetException {
        try {
          Gemini().getApiKey();
          return (Gemini(), Gemini().defaultModel);
        } on ApiKeyNotSetException {
          try {
            Anthropic().getApiKey();
            return (Anthropic(), Anthropic().defaultModel);
          } on ApiKeyNotSetException {
            return null;
          }
        }
      }
    }
    final [providerType, model] = providerModel.split('|');
    return switch (providerType) {
      'openai' => (OpenAI(), model),
      'anthropic' => (Anthropic(), model),
      'gemini' => (Gemini(), model),
      _ => throw Exception('Invalid provider type: $providerType'),
    };
  }

  static (LLMProvider, String)? getSummarizationProviderAndModel() =>
      _getProvider(summarizationProviderKey);
  static (LLMProvider, String)? getImageCaptionProviderAndModel() =>
      _getProvider(imageCaptionProviderKey);
  static (LLMProvider, String)? getPromptGenerationProviderAndModel() =>
      _getProvider(promptGenerationProviderKey);
  static (LLMProvider, String)? getAudioTranscriptionProviderAndModel() =>
      _getProvider(audioTranscriptionProviderKey);

  static void _setProvider(LLMProvider provider, String model, String key) =>
      Database().stringRef.put(
            key,
            switch (provider) {
              Anthropic() => 'anthropic|$model',
              Gemini() => 'gemini|$model',
              OpenAI() => 'openai|$model',
            },
          );

  static void setSummarizationProviderAndModel(LLMProvider provider, String model) =>
      _setProvider(provider, model, summarizationProviderKey);
  static void setImageCaptionProviderAndModel(LLMProvider provider, String model) =>
      _setProvider(provider, model, imageCaptionProviderKey);
  static void setPromptGenerationProviderAndModel(LLMProvider provider, String model) =>
      _setProvider(provider, model, promptGenerationProviderKey);
  static void setAudioTranscriptionProviderAndModel(LLMProvider provider, String model) =>
      _setProvider(provider, model, audioTranscriptionProviderKey);

  static String getSummarizationPrompt() =>
      Database().stringRef.get(summarizationPromptKey) ??
      defaultSummarizationPrompt;
  static String getImageCaptionPrompt() =>
      Database().stringRef.get(imageCaptionPromptKey) ??
      defaultImageCaptionPrompt;
  static String getPromptGenerationPrompt() =>
      Database().stringRef.get(promptGenerationPromptKey) ??
      defaultPromptGenerationPrompt;

  static String? setSummarizationPrompt(String prompt) {
    if (prompt.contains('{{CONTENT}}')) {
      Database().stringRef.put(summarizationPromptKey, prompt);
      return null;
    }
    return 'Prompt must contain "{{CONTENT}}"';
  }

  static String? setImageCaptionPrompt(String prompt) {
    Database().stringRef.put(imageCaptionPromptKey, prompt);
    return null;
  }

  static String? setPromptGenerationPrompt(String prompt) {
    if (prompt.contains('{{INSTRUCTIONS}}')) {
      Database().stringRef.put(promptGenerationPromptKey, prompt);
      return null;
    }
    return 'Prompt Generation Prompt must contain "{{INSTRUCTIONS}}"';
  }
}
