part of '../prompt_page.dart';

class _PPProviders extends StatelessWidget {
  const _PPProviders({required this.db, required this.id, required this.child});

  final Database db;
  final int id;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider<Database>.value(value: db),
      StreamProvider<Prompt?>(
        initialData: null,
        create: (context) => db.streamPrompt(id),
      ),
      ValueProvider<ValueNotifier<_PromptContentViewState>>(
        create: (_) => ValueNotifier(_PromptContentViewState.edit),
        onDisposed: (_, __) => db.recordPromptOpened(id),
      ),
    ],
    child: _PPLLMScope(
      child: _PPBlockScope(
        promptId: id,
        child: _PPBlockContentScope(
          child: _PPFileTreeScope(child: _KeyboardListener(child: child)),
        ),
      ),
    ),
  );
}

// -----------------------------------------------------------------------------
// Enums & Typedefs
// -----------------------------------------------------------------------------

enum _PromptContentViewState { edit, preview }
