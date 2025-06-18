// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:tiktoken_tokenizer_gpt4o_o1/tiktoken_tokenizer_gpt4o_o1.dart';

import '../../core/core.dart';
import '../../database/database.dart';
import '../other_services/mime_utils.dart';

part 'anthropic.dart';
part 'gemini.dart';
part 'openai.dart';

part 'model_preferences.dart';
part 'llm_use_cases.dart';

final kAllLLMProviders = [OpenAI(), Anthropic(), Gemini()];

/// Base class for LLM (Large Language Model) providers.
///
/// This abstract class defines the common interface that all LLM providers must implement.
/// Each provider (OpenAI, Anthropic, Gemini etc.) will extend this class and provide
/// their own implementations of these methods.
sealed class LLMProvider with ProviderWithApiKey, _EstimateTokensMixin {
  /// Creates a new LLM provider instance.
  const LLMProvider({this.apiKey});

  @override
  final String? apiKey;

  String get defaultModel;

  /// List all models supported by the provider.
  Future<List<String>> listModels();

  /// Counts the number of tokens in a given text and returns the count and the
  /// name of the counting method used.
  ///
  /// Takes a [text] string and returns the number of tokens it contains according
  /// to the provider's tokenization scheme.
  ///
  /// Different providers may use different tokenization approaches, so the token
  /// count may vary between providers for the same input text.
  Future<(int, String)> countTokens(String text, [String? model]) {
    if (this is! OpenAI) {
      try {
        getApiKey();
      } on ApiKeyNotSetException catch (e) {
        debugPrint(
          'API key not set for ${e.provider}. Falling back to token estimation.',
        );
        return SynchronousFuture(estimateTokens(text, model));
      }
    }
    try {
      return _countTokens(text, model);
    } on Exception catch (e) {
      debugPrint(
        'Failed to count tokens: $e. Falling back to token estimation.',
      );
      return SynchronousFuture(estimateTokens(text, model));
    }
  }

  /// Private implementation of [countTokens] by subclasses.
  Future<(int, String)> _countTokens(String text, [String? model]);

  /// Counts the number of tokens given inline data.
  ///
  /// Subclasses may support different [mimeType]s of data.
  Future<int> countTokensFromData(
    Uint8List data,
    String mimeType, [
    String? model,
  ]);

  /// Summarizes text using the chosen model.
  ///
  /// Takes [content] text to summarize and an optional [summarizationPrompt] to
  /// guide the summarization style/format.
  ///
  /// Returns a summarized version of the input content as a string.
  Future<String> summarize(
    String content, [
    String? summarizationPrompt,
    String? model,
  ]);

  /// Captions an image using the model's vision capabilities.
  ///
  /// Takes raw [image] data as [Uint8List] and an optional [captionPrompt] to
  /// guide the captioning style/format.
  ///
  /// Returns a natural language description of the image content.
  Future<String> captionImage(
    Uint8List image, [
    String mimeType = 'image/jpeg',
    String? captionPrompt,
    String? model,
  ]);

  /// Transcribes audio to text.
  ///
  /// Takes raw [audio] data as [Uint8List] and converts spoken words to text.
  ///
  /// Returns the transcribed text as a string.
  Future<String> transcribeAudio(
    Uint8List audio, [
    String mimeType = 'audio/wav',
    String? model,
  ]);

  /// Generates a prompt from the given instruction (meta-prompting).
  ///
  /// Takes [instructions] describing the desired prompt and an optional [metaPrompt]
  /// to guide the prompt generation style/format.
  ///
  /// Returns a generated prompt string that can be used with LLM models.
  Future<String> generatePrompt(
    String instructions, [
    String? metaPrompt,
    String? model,
  ]);

  Map<String, String> get _info => _llmProviderInfo[this]!;

  @override
  String get name => _info['name']!;
  @override
  String get docsUrl => _info['docs_page']!;
  @override
  String get consoleUrl => _info['api_key_page']!;
  @override
  String get logoPath => _info['light_logo_path']!;
  @override
  String get darkLogoPath => _info['dark_logo_path']!;
  @override
  String? get description => null;
}

// -----------------------------------------------------------------------------
// General Info
// -----------------------------------------------------------------------------

Map<LLMProvider, Map<String, String>> _llmProviderInfo = {
  OpenAI(): {
    'name': 'OpenAI',
    'docs_page': 'https://platform.openai.com/docs/introduction',
    'api_key_page': 'https://platform.openai.com/api-keys',
    'light_logo_path': 'assets/images/openai_light.svg',
    'dark_logo_path': 'assets/images/openai_dark.svg',
  },
  Anthropic(): {
    'name': 'Anthropic',
    'docs_page': 'https://docs.anthropic.com/en/home',
    'api_key_page': 'https://console.anthropic.com/settings/keys',
    'light_logo_path': 'assets/images/anthropic_light.svg',
    'dark_logo_path': 'assets/images/anthropic_dark.png',
  },
  Gemini(): {
    'name': 'Gemini',
    'docs_page': 'https://ai.google.dev/gemini-api/docs',
    'api_key_page': 'https://aistudio.google.com/apikey',
    'light_logo_path': 'assets/images/google.svg',
    'dark_logo_path': 'assets/images/google.svg',
  },
};

// -----------------------------------------------------------------------------
// Preferences Mixin
// -----------------------------------------------------------------------------

mixin ProviderWithApiKey {
  String? get apiKey;
  String get apiKeyKey;
  String get name;
  String get logoPath;
  String get darkLogoPath;
  String get docsUrl;
  String get consoleUrl;
  String? get description;

  String getApiKey() {
    if (this.apiKey != null) {
      return this.apiKey!;
    }
    final apiKey = Database().stringRef.get(apiKeyKey);
    if (apiKey == null || apiKey.isEmpty) {
      throw ApiKeyNotSetException(runtimeType.toString());
    }
    return apiKey;
  }

  Stream<bool> isSetUp() async* {
    yield hasSetUp();
    yield* Database().stringRef
        .watch(key: apiKeyKey)
        .map((e) => e.value != null);
  }

  bool hasSetUp() {
    try {
      getApiKey();
      return true;
    } on ApiKeyNotSetException {
      return false;
    }
  }

  void setApiKey(String apiKey) {
    Database().stringRef.put(apiKeyKey, apiKey);
  }
}

mixin _EstimateTokensMixin {
  /// Crudely estimates the number of tokens in a given text.
  ///
  /// This is a simple heuristic based on the number of characters in the text.
  /// Best for English texts, otherwise accuracy is low and should be used as a
  /// last resort.
  (int, String) estimateTokens(String text, [String? model]) {
    return (text.characterCount ~/ 4, '¼ Estimate');
  }
}

// -----------------------------------------------------------------------------
// Exceptions
// -----------------------------------------------------------------------------

sealed class LLMException implements Exception {
  const LLMException();
}

final class ApiKeyNotSetException implements LLMException {
  const ApiKeyNotSetException(this.provider);
  final String provider;

  @override
  String toString() => 'API key not set for ${provider.runtimeType}.';
}

final class MissingProviderException implements LLMException {
  const MissingProviderException(this.useCase);
  final String useCase;
  @override
  String toString() => 'LLM provider has not been set up for $useCase.';
}

/// Thrown by [SummarizeContentUseCase] when a transcript is not found for a
/// given audio, video, or YouTube block that user would like to summarize.
final class MissingTranscriptException implements LLMException {
  const MissingTranscriptException();
  @override
  String toString() =>
      'No transcript found for the block. Please transcribe the content first.';
}

/// Thrown when a local file is not found for a given block.
final class MissingLocalFileException implements LLMException {
  const MissingLocalFileException();
  @override
  String toString() => 'Local file not found.';
}

/// Thrown when a custom prompt is not provided for [PromptGenerationUseCase].
/// This use case requires specific instructions at "runtime".
final class MissingInstructionsException implements LLMException {
  const MissingInstructionsException();
  @override
  String toString() => 'Please provide instructions for the prompt generation.';
}
