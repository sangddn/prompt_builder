part of 'llm_providers.dart';

const kAllLLMUseCases = [
  SummarizeContentUseCase(),
  DescribeImagesUseCase(),
  GeneratePromptUseCase(),
  TranscribeAudioUseCase(),
];

/// Base class for all LLM use cases that can be applied to prompt blocks.
///
/// Each use case represents a specific AI capability like summarization,
/// image description, etc. Use cases handle:
/// - Which providers & models can be used
/// - What types of blocks they can process
/// - How to customize the prompting behavior
/// - Applying the AI operation to blocks
sealed class LLMUseCase {
  const LLMUseCase();

  /// Display name shown in the UI
  String get name;

  /// User-friendly description of what this use case does
  String get description;

  /// Instructions for how to customize the prompt template
  String get promptInstructions;

  /// Default prompt template if none is set
  String? get defaultPrompt;

  /// List of LLM providers that support this use case
  List<LLMProvider> get providers;

  /// Whether this use case can be applied to the given block
  bool supports(PromptBlock block);

  /// Gets the currently selected provider and model
  /// Returns null if none selected
  (LLMProvider provider, String model)? getProviderAndModel();

  /// Updates the selected provider and model
  ///
  /// Throws [ArgumentError] if the provider is not supported by this use case
  void setProviderAndModel(LLMProvider provider, String model) {
    if (!providers.contains(provider)) {
      throw ArgumentError('Provider $provider is not supported by $name');
    }
    _setProviderAndModel(provider, model);
  }

  /// Internal method to set provider and model after validation
  void _setProviderAndModel(LLMProvider provider, String model);

  /// Gets the current prompt template
  /// Returns null if none set
  String? getPrompt();

  /// Updates the prompt template
  ///
  /// Throws [ArgumentError] if the prompt is empty or invalid
  void setPrompt(String prompt) {
    if (prompt.isEmpty) throw ArgumentError('Prompt cannot be empty');
    _setPrompt(prompt);
  }

  /// Internal method to set prompt after validation
  void _setPrompt(String prompt);

  /// Applies this use case to the given block
  ///
  /// Throws:
  /// - [ArgumentError] if block type is not supported
  /// - [StateError] if no provider/model is selected
  Future<void> apply(
    Database db,
    PromptBlock block, {
    String? customPrompt,
  }) async {
    if (!supports(block)) {
      throw ArgumentError('Block type ${block.type} is not supported by $name');
    }

    final (provider, model) = getProviderAndModel() ?? (null, null);
    if (provider == null) {
      throw MissingProviderException(name);
    }

    await _apply(db, block, provider, model, customPrompt);
  }

  /// Internal method to apply the use case after validation
  Future<void> _apply(
    Database db,
    PromptBlock block,
    LLMProvider provider,
    String? model,
    String? customPrompt,
  );
}

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
  List<LLMProvider> get providers => kAllLLMProviders;

  @override
  bool supports(PromptBlock block) =>
      block.summary == null &&
      (((block.type == BlockType.webUrl || block.type == BlockType.localFile) &&
              block.textContent != null) ||
          ((block.type == BlockType.audio ||
                  block.type == BlockType.video ||
                  block.type == BlockType.youtube) &&
              block.transcript != null));

  @override
  (LLMProvider provider, String model)? getProviderAndModel() =>
      ModelPreferences.getSummarizationProviderAndModel();

  @override
  void _setProviderAndModel(LLMProvider provider, String model) {
    ModelPreferences.setSummarizationProviderAndModel(provider, model);
  }

  @override
  String? getPrompt() => ModelPreferences.getSummarizationPrompt();

  @override
  void _setPrompt(String prompt) =>
      ModelPreferences.setSummarizationPrompt(prompt);

  @override
  Future<void> _apply(
    Database db,
    PromptBlock block,
    LLMProvider provider,
    String? model,
    String? customPrompt,
  ) async {
    final prompt = customPrompt ?? getPrompt();
    if (prompt == null) return;
    final content = block.getSummarizableContent();
    if (content == null) throw const MissingTranscriptException();
    final summary = await provider.summarize(content, prompt, model);
    try {
      return db.updateBlock(block.id, summary: summary);
    } catch (e) {
      debugPrint('Failed to update block with summary: $e');
      rethrow;
    }
  }
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
  List<LLMProvider> get providers => kAllLLMProviders;

  @override
  bool supports(PromptBlock block) =>
      block.caption == null && block.type == BlockType.image;

  @override
  (LLMProvider provider, String model)? getProviderAndModel() =>
      ModelPreferences.getImageCaptionProviderAndModel();

  @override
  String? getPrompt() => ModelPreferences.getImageCaptionPrompt();

  @override
  void _setProviderAndModel(LLMProvider provider, String model) {
    ModelPreferences.setImageCaptionProviderAndModel(provider, model);
  }

  @override
  void _setPrompt(String prompt) =>
      ModelPreferences.setImageCaptionPrompt(prompt);

  @override
  Future<void> _apply(
    Database db,
    PromptBlock block,
    LLMProvider provider,
    String? model,
    String? customPrompt,
  ) async {
    final prompt = customPrompt ?? getPrompt();
    if (prompt == null) return;
    final path = block.filePath!;
    final file = File(path);
    if (!file.existsSync()) throw const MissingLocalFileException();
    try {
      final bytes = await file.readAsBytes();
      final description = await provider.captionImage(
        bytes,
        block.mimeType ?? 'image/jpeg',
        prompt,
        model,
      );
      return db.updateBlock(block.id, caption: description);
    } catch (e) {
      debugPrint('Failed to update block with image caption: $e');
      rethrow;
    }
  }
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
  List<LLMProvider> get providers => kAllLLMProviders;

  /// [GeneratePromptUseCase] is not supported for any block type. It is only
  /// used to generate a new block.
  @override
  bool supports(PromptBlock block) => false;

  @override
  (LLMProvider provider, String model)? getProviderAndModel() =>
      ModelPreferences.getPromptGenerationProviderAndModel();

  @override
  void _setProviderAndModel(LLMProvider provider, String model) {
    ModelPreferences.setPromptGenerationProviderAndModel(provider, model);
  }

  @override
  String? getPrompt() => ModelPreferences.getPromptGenerationPrompt();

  @override
  void _setPrompt(String prompt) =>
      ModelPreferences.setPromptGenerationPrompt(prompt);

  @override
  Future<void> _apply(
    Database db,
    PromptBlock block,
    LLMProvider provider,
    String? model,
    String? customPrompt,
  ) async {
    throw UnsupportedError('Cannot apply GeneratePromptUseCase to a block');
  }

  Future<String?> generatePrompt(String prompt) async {
    final metaPrompt = getPrompt();
    if (metaPrompt == null) return null;
    final (provider, model) = getProviderAndModel() ?? (null, null);
    if (provider == null) throw MissingProviderException(name);
    return provider.generatePrompt(prompt, metaPrompt, model);
  }
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
  bool supports(PromptBlock block) =>
      block.transcript == null &&
      (block.type == BlockType.audio || block.type == BlockType.video);

  @override
  (LLMProvider provider, String model)? getProviderAndModel() =>
      ModelPreferences.getAudioTranscriptionProviderAndModel();

  @override
  void _setProviderAndModel(LLMProvider provider, String model) {
    ModelPreferences.setAudioTranscriptionProviderAndModel(provider, model);
  }

  @override
  String? getPrompt() => null;

  @override
  void _setPrompt(String prompt) =>
      throw UnsupportedError(
        'No prompt customization available for audio transcription',
      );

  @override
  Future<void> _apply(
    Database db,
    PromptBlock block,
    LLMProvider provider,
    String? model,
    String? customPrompt,
  ) async {
    final path = block.filePath!;
    final file = File(path);
    if (!file.existsSync()) throw const MissingLocalFileException();
    final bytes = await file.readAsBytes();
    final transcript = await provider.transcribeAudio(
      bytes,
      block.mimeType ?? 'audio/wav',
      model,
    );
    return db.updateBlock(block.id, transcript: transcript);
  }

  Future<String> transcribeAudio(String path) async {
    final file = File(path);
    if (!file.existsSync()) throw const MissingLocalFileException();
    final bytes = await file.readAsBytes();
    final (provider, model) = getProviderAndModel() ?? (null, null);
    if (provider == null) throw MissingProviderException(name);
    final transcript = await provider.transcribeAudio(
      bytes,
      'audio/wav',
      model,
    );
    return transcript;
  }
}
