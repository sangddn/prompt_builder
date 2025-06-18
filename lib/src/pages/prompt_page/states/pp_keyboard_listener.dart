part of '../prompt_page.dart';

class _KeyboardListener extends StatelessWidget {
  const _KeyboardListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final focusNodeProvider = ListenableProvider<FocusNode>(
      create: (context) {
        final bindings = {
          _cmdShiftC: () async {
            await Clipboard.setData(ClipboardData(text: context.getContent()));
            if (!context.mounted) return;
            final notifier = context.read<ValueNotifier<_PromptCopiedEvent?>>();
            notifier.value = _PromptCopiedEvent();
            Future.delayed(
              const Duration(milliseconds: 100),
              () => context.mounted ? notifier.value = null : null,
            );
          },
          _cmdE: () {
            final notifier =
                context.read<ValueNotifier<_PromptContentViewState>>();
            if (notifier.value == _PromptContentViewState.edit) {
              notifier.value = _PromptContentViewState.preview;
            } else {
              notifier.value = _PromptContentViewState.edit;
            }
          },
          _cmdP: () => _showPathSearchDialog(context),
          _cmdF: () => _showWebSearchDialog(context),
          _cmdO: () => context.pickFolder(),
          _cmdShiftV: () async {
            final reader = await ClipboardService.read();
            if (reader == null || !context.mounted) return;
            context.handleDataReaders([reader]);
          },
        };
        return FocusNode(
          skipTraversal: true,
          onKeyEvent: (node, event) {
            var result = KeyEventResult.ignored;
            for (final ShortcutActivator activator in bindings.keys) {
              if (activator.accepts(event, HardwareKeyboard.instance)) {
                bindings[activator]!.call();
                result = KeyEventResult.handled;
              }
            }
            return result;
          },
        );
      },
    );

    return MultiProvider(
      providers: [
        ValueProvider<ValueNotifier<_PromptCopiedEvent?>>(
          create: (_) => ValueNotifier(null),
        ),
        focusNodeProvider,
      ],
      builder: (context, child) {
        return Focus(
          focusNode: context.read<FocusNode>(),
          canRequestFocus: false,
          child: FocusScope(
            autofocus: true,
            descendantsAreFocusable: true,
            descendantsAreTraversable: true,
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

const _cmdShiftC = SingleActivator(
  LogicalKeyboardKey.keyC,
  meta: true,
  shift: true,
);
const _cmdE = SingleActivator(LogicalKeyboardKey.keyE, meta: true);
const _cmdP = SingleActivator(LogicalKeyboardKey.keyP, meta: true);
const _cmdF = SingleActivator(LogicalKeyboardKey.keyF, meta: true);
const _cmdO = SingleActivator(LogicalKeyboardKey.keyO, meta: true);
const _cmdShiftV = SingleActivator(
  LogicalKeyboardKey.keyV,
  meta: true,
  shift: true,
);
