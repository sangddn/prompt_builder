part of '../project_page.dart';

class _TitleController extends TextEditingController {
  _TitleController({super.text});
}

class _NotesController extends TextEditingController {
  _NotesController({super.text});
}

class _SnippetTagNotifier extends TagFilterNotifier {
  _SnippetTagNotifier(super.value);
}

class _PromptTagNotifier extends TagFilterNotifier {
  _PromptTagNotifier(super.value);
}

enum _SnippetGridState { collapsed, expanded }

class _SnippetGridStateNotifier extends ValueNotifier<_SnippetGridState> {
  _SnippetGridStateNotifier() : super(_SnippetGridState.expanded);
}

enum _PromptGridState { collapsed, expanded }

class _PromptGridStateNotifier extends ValueNotifier<_PromptGridState> {
  _PromptGridStateNotifier() : super(_PromptGridState.expanded);
}

extension _ProjectExtension on BuildContext {
  Project? get project => read<Project?>();
  bool isReady() => select((Project? p) => p != null);

  _SnippetGridStateNotifier get snippetGridStateNotifier => read();
  _PromptGridStateNotifier get promptGridStateNotifier => read();

  bool snippetGridIsExpanded() =>
      watch<_SnippetGridStateNotifier>().value == _SnippetGridState.expanded;
  bool promptGridIsExpanded() =>
      watch<_PromptGridStateNotifier>().value == _PromptGridState.expanded;

  void toggleSnippetGrid([_SnippetGridState? newState]) {
    snippetGridStateNotifier.value =
        newState ??
        (snippetGridStateNotifier.value == _SnippetGridState.expanded
            ? _SnippetGridState.collapsed
            : _SnippetGridState.expanded);
  }

  void togglePromptGrid([_PromptGridState? newState]) {
    promptGridStateNotifier.value =
        newState ??
        (promptGridStateNotifier.value == _PromptGridState.expanded
            ? _PromptGridState.collapsed
            : _PromptGridState.expanded);
  }
}
