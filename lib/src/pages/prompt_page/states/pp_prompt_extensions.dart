part of '../prompt_page.dart';

extension _PPPromptExtensions on BuildContext {
  Prompt? get prompt => read();
  T selectPrompt<T>(T Function(Prompt?) fn) => select(fn);

  bool isPromptLoading() => selectPrompt((p) => p == null);
}
