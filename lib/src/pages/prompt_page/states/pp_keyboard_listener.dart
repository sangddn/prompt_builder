part of '../prompt_page.dart';

class _KeyboardListener extends StatelessWidget {
  const _KeyboardListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<FocusScopeNode>(create: (_) => FocusScopeNode()),
        ValueProvider<ValueNotifier<_PromptCopiedEvent?>>(
          create: (_) => ValueNotifier(null),
        ),
      ],
      builder: (context, child) {
        final bindings = {
          const SingleActivator(
            LogicalKeyboardKey.keyC,
            meta: true,
            shift: true,
          ): () async {
            await Clipboard.setData(ClipboardData(text: context.getContent()));
            if (!context.mounted) return;
            final notifier = context.read<ValueNotifier<_PromptCopiedEvent?>>();
            notifier.value = _PromptCopiedEvent();
            Future.delayed(
              const Duration(milliseconds: 100),
              () => context.mounted ? notifier.value = null : null,
            );
          },
          const SingleActivator(LogicalKeyboardKey.keyE, meta: true): () {
            final notifier =
                context.read<ValueNotifier<_PromptContentViewState>>();
            if (notifier.value == _PromptContentViewState.edit) {
              notifier.value = _PromptContentViewState.preview;
            } else {
              notifier.value = _PromptContentViewState.edit;
            }
          },
          const SingleActivator(LogicalKeyboardKey.keyP, meta: true): () {
            _showPathSearchDialog(context);
          },
          const SingleActivator(LogicalKeyboardKey.keyF, meta: true): () {
            _showWebSearchDialog(context);
          },
          const SingleActivator(LogicalKeyboardKey.keyO, meta: true): () {
            context.pickFolder();
          },
          const SingleActivator(LogicalKeyboardKey.keyV, meta: true): () async {
            final reader = await ClipboardService.read();
            if (reader == null || !context.mounted) return;
            context.handleDataReaders([reader]);
          },
        };
        return CallbackShortcuts(
          bindings: bindings,
          child: FocusScope(
            node: context.read(),
            autofocus: true,
            child: child!,
          ),
        );
      },
      child: child,
    );
  }
}

// Just a marker class to indicate that the prompt has been copied.
final class _PromptCopiedEvent {}
