part of 'llm_providers.dart';

sealed class LLMUseCase {
  const LLMUseCase();

  String get name;
  String get description;
  String get promptInstructions;
  String? get defaultPrompt;

  List<LLMProvider> get providers;

  (LLMProvider provider, String model)? getProviderAndModel();
  void setProviderAndModel(LLMProvider provider, String model);

  void setPrompt(String prompt);
}

const kAllLLMUseCases = [
  SummarizeContentUseCase(),
  DescribeImagesUseCase(),
  GeneratePromptUseCase(),
  TranscribeAudioUseCase(),
];

class SummarizeContentUseCase extends LLMUseCase {
  const SummarizeContentUseCase();

  @override
  String get name => 'Summarize Content';

  @override
  String get description =>
      'Summarize content from large files, web pages, and YouTube transcripts before using them in prompts. Useful for saving tokens or improving performance.';

  @override
  String get promptInstructions =>
      'Use "{{CONTENT}}" as a placeholder for the content to summarize.';

  @override
  String? get defaultPrompt => ModelPreferences.defaultSummarizationPrompt;

  @override
  List<LLMProvider> get providers => [OpenAI(), Anthropic(), Gemini()];

  @override
  (LLMProvider provider, String model)? getProviderAndModel() =>
      ModelPreferences.getSummarizationProviderAndModel();

  @override
  void setProviderAndModel(LLMProvider provider, String model) {
    ModelPreferences.setSummarizationProviderAndModel(provider, model);
  }

  @override
  void setPrompt(String prompt) =>
      ModelPreferences.setSummarizationPrompt(prompt);
}

class DescribeImagesUseCase extends LLMUseCase {
  const DescribeImagesUseCase();

  @override
  String get name => 'Describe Images';

  @override
  String get description =>
      'Generate descriptions for images to add into prompts (instead of adding images).';

  @override
  String get promptInstructions =>
      'Instructions for how the image should be described.';

  @override
  String? get defaultPrompt => ModelPreferences.defaultImageCaptionPrompt;

  @override
  List<LLMProvider> get providers => [OpenAI(), Anthropic(), Gemini()];

  @override
  (LLMProvider provider, String model)? getProviderAndModel() =>
      ModelPreferences.getImageCaptionProviderAndModel();

  @override
  void setProviderAndModel(LLMProvider provider, String model) {
    ModelPreferences.setImageCaptionProviderAndModel(provider, model);
  }

  @override
  void setPrompt(String prompt) =>
      ModelPreferences.setImageCaptionPrompt(prompt);
}

class GeneratePromptUseCase extends LLMUseCase {
  const GeneratePromptUseCase();

  @override
  String get name => 'Generate Prompt';

  @override
  String get description =>
      'Generate a prompt based on your instructions (meta-prompting).';

  @override
  String get promptInstructions =>
      'Use "{{INSTRUCTIONS}}" as a placeholder for the instructions to generate a prompt.';

  @override
  String? get defaultPrompt => ModelPreferences.defaultPromptGenerationPrompt;

  @override
  List<LLMProvider> get providers => [OpenAI(), Anthropic(), Gemini()];

  @override
  (LLMProvider provider, String model)? getProviderAndModel() =>
      ModelPreferences.getPromptGenerationProviderAndModel();

  @override
  void setProviderAndModel(LLMProvider provider, String model) {
    ModelPreferences.setPromptGenerationProviderAndModel(provider, model);
  }

  @override
  void setPrompt(String prompt) =>
      ModelPreferences.setPromptGenerationPrompt(prompt);
}

class TranscribeAudioUseCase extends LLMUseCase {
  const TranscribeAudioUseCase();

  @override
  String get name => 'Transcribe Audio';

  @override
  String get description =>
      'Transcribe audio files to text using OpenAI Whisper or Gemini. Useful when the model you are using does not support audios.';

  @override
  String get promptInstructions =>
      'No prompt customization available for audio transcription.';

  @override
  String? get defaultPrompt => null;

  @override
  List<LLMProvider> get providers => [OpenAI(), Gemini()];

  @override
  (LLMProvider provider, String model)? getProviderAndModel() =>
      ModelPreferences.getAudioTranscriptionProviderAndModel();

  @override
  void setProviderAndModel(LLMProvider provider, String model) {
    ModelPreferences.setAudioTranscriptionProviderAndModel(provider, model);
  }

  @override
  void setPrompt(String prompt) => throw UnsupportedError(
        'No prompt customization available for audio transcription',
      );
}
