import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:tiktoken_tokenizer_gpt4o_o1/tiktoken_tokenizer_gpt4o_o1.dart';

import '../../database/database.dart';

part 'anthropic.dart';
part 'gemini.dart';
part 'openai.dart';

/// Base class for LLM (Large Language Model) providers.
///
/// This abstract class defines the common interface that all LLM providers must implement.
/// Each provider (OpenAI, Anthropic, Gemini etc.) will extend this class and provide
/// their own implementations of these methods.
sealed class LLMProvider {
  /// Creates a new LLM provider instance.
  const LLMProvider();

  static const summarizationPromptKey = 'summarization_prompt';
  static const imageCaptionPromptKey = 'image_caption_prompt';
  static const promptGenerationPromptKey = 'prompt_generation_prompt';

  static const defaultSummarizationPrompt =
      r'Summarize the following text:\n\n{{CONTENT}}';
  static const defaultImageCaptionPrompt = r'Describe the following image.';
  static const defaultPromptGenerationPrompt =
      r'Generate a prompt for an LLM based on the following user instruction:\n\n{{INSTRUCTIONS}}';

  String _getSummarizationPrompt() =>
      Database().stringRef.get(summarizationPromptKey) ??
      defaultSummarizationPrompt;
  String _getImageCaptionPrompt() =>
      Database().stringRef.get(imageCaptionPromptKey) ??
      defaultImageCaptionPrompt;
  String _getPromptGenerationPrompt() =>
      Database().stringRef.get(promptGenerationPromptKey) ??
      defaultPromptGenerationPrompt;

  /// Counts the number of tokens in a given text.
  ///
  /// Takes a [text] string and returns the number of tokens it contains according
  /// to the provider's tokenization scheme.
  ///
  /// Different providers may use different tokenization approaches, so the token
  /// count may vary between providers for the same input text.
  FutureOr<int> countTokens(String text, [String? model]);

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
    String? captionPrompt,
    String? model,
  ]);

  /// Transcribes audio to text.
  ///
  /// Takes raw [audio] data as [Uint8List] and converts spoken words to text.
  ///
  /// Returns the transcribed text as a string.
  Future<String> transcribeAudio(Uint8List audio, [String? model]);

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
}
