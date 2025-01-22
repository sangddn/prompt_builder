part of '../prompt_page.dart';

class _NewBlockActions extends StatelessWidget {
  const _NewBlockActions(this.index);
  const _NewBlockActions.first() : index = -1;
  const _NewBlockActions.last() : index = -2;

  /// The position of these actions as a divider between 2 existing blocks (or
  /// before the first block and after the last).
  final int index;

  @override
  Widget build(BuildContext context) {
    final alwaysShow = index == -2;
    return HoverTapBuilder(
      builder: (context, isHovered) => SizedBox(
        height: alwaysShow ? 48.0 : 24.0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (index >= 0)
              const Divider(
                height: .5,
                thickness: .5,
                indent: 16.0,
                endIndent: 16.0,
              ),
            MultiProvider(
              providers: [
                Provider<int>.value(value: index),
                ChangeNotifierProvider<ShadPopoverController>(
                  create: (_) => ShadPopoverController(),
                ),
                ChangeNotifierProvider<_GeneratePromptController>(
                  create: (_) => _GeneratePromptController(),
                ),
                ChangeNotifierProvider<VoiceInputController>(
                  create: (_) => VoiceInputController(),
                ),
              ],
              builder: (context, child) {
                final shouldShow = alwaysShow ||
                    isHovered ||
                    (context.watch<ShadPopoverController?>()?.isOpen ??
                        false) ||
                    (context.watch<_GeneratePromptController?>()?.isOpen ??
                        false) ||
                    (context.watch<VoiceInputController?>()?.isOpen ?? false);
                return StateAnimations.fade(
                  duration: Effects.veryShortDuration,
                  shouldShow ? child! : const SizedBox.shrink(),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6.0,
                children: [
                  _AddTextButton(),
                  _SnippetButton(),
                  _GeneratePromptButton(),
                  _VoiceInputButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _NewBlockExtension on BuildContext {
  Future<void> _createTextBlock([
    String? displayName,
    String? textContent,
  ]) async {
    final index = read<int>();
    await createTextBlockAtIndex(
      index == -1
          ? 0
          : index == -2
              ? promptBlocks.length
              : index + 1,
      displayName: displayName,
      textContent: textContent,
    );
  }
}

/// A button that allows the user to add an empty text block.
class _AddTextButton extends StatelessWidget {
  const _AddTextButton();

  @override
  Widget build(BuildContext context) => CButton(
        tooltip: 'Add Text',
        onTap: context._createTextBlock,
        padding: k8H4VPadding,
        color: PColors.opaqueLightGray.resolveFrom(context),
        child: Icon(
          LucideIcons.plus,
          size: 16.0,
          color: PColors.textGray.resolveFrom(context),
        ),
      );
}

/// A button that allows the user to add a snippet as a new text block.
class _SnippetButton extends StatelessWidget {
  const _SnippetButton();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ShadPopoverController>();
    final isOpen = controller.isOpen;
    return ShadPopover(
      controller: controller,
      popover: (context) => SnippetPicker(
        database: context.db,
        onSelected: (snippet) async {
          controller.hide();
          final toaster = context.toaster;
          try {
            await context._createTextBlock(snippet.title, snippet.content);
            toaster.show(const ShadToast(title: Text('Snippet added')));
          } catch (e) {
            debugPrint('Error updating block: $e');
            toaster.show(
              ShadToast.destructive(
                title: const Text('Error adding snippet.'),
                description: Text('Error: $e'),
              ),
            );
          }
        },
      ),
      padding: EdgeInsets.zero,
      child: CButton(
        tooltip: 'Add Snippet',
        onTap: controller.toggle,
        padding: k8H4VPadding,
        color: isOpen
            ? context.colorScheme.primary
            : PColors.opaqueLightGray.resolveFrom(context),
        child: Icon(
          HugeIcons.strokeRoundedQuoteDown,
          size: 16.0,
          color: isOpen
              ? context.colorScheme.primaryForeground
              : PColors.textGray.resolveFrom(context),
        ),
      ),
    );
  }
}

/// Wrapper class for the [ShadPopoverController] for the [_GeneratePromptButton]
/// to distinguish it from the controller for the [_SnippetButton].
class _GeneratePromptController extends ShadPopoverController {}

/// A button that allows the user to generate a prompt and add it as a new text
/// block.
class _GeneratePromptButton extends StatelessWidget {
  const _GeneratePromptButton();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<_GeneratePromptController>();
    final isOpen = controller.isOpen;
    const handler = GeneratePromptUseCase();
    var isGenerating = false;
    final generateButton = StatefulBuilder(
      builder: (context, setState) {
        return ShadButton(
          onPressed: () async {
            final toaster = context.toaster;
            final instructions = context.read<TextEditingController>().text;
            if (instructions.isEmpty) return;
            setState(() => isGenerating = true);
            try {
              final newPrompt = await handler.generatePrompt(instructions);
              if (newPrompt == null || newPrompt.isEmpty || !context.mounted) {
                return;
              }
              await context._createTextBlock(null, newPrompt);
              toaster.show(
                ShadToast(
                  title: const Text('Prompt generated and added'),
                  description: Text('"$newPrompt"', maxLines: 10),
                ),
              );
              if (!context.mounted) return;
              controller.hide();
            } catch (e) {
              debugPrint('Error updating block: $e');
              toaster.show(
                ShadToast.destructive(
                  title: const Text('Error generating prompt.'),
                  description: Text('$e'),
                ),
              );
            }
          },
          child: TranslationSwitcher.top(
            child: GrayShimmer(
              key: ValueKey(isGenerating),
              enableShimmer: isGenerating,
              child: Text(isGenerating ? 'Generating…' : 'Generate'),
            ),
          ),
        );
      },
    );
    return ShadPopover(
      controller: controller,
      popover: (context) => ValueProvider<TextEditingController>(
        create: (_) => TextEditingController(),
        builder: (context, footer) {
          return SizedBox(
            width: 300.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  controller: context.read(),
                  minLines: 3,
                  maxLines: 10,
                  style: context.textTheme.p,
                  decoration: InputDecoration(
                    hintText:
                        'Describe the desired prompt, such as what you want the model to do.',
                    hintStyle: context.textTheme.muted,
                    border: InputBorder.none,
                  ),
                ),
                const Gap(16.0),
                footer!,
              ],
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShadButton.outline(
              onPressed: controller.hide,
              child: const Text('Cancel'),
            ),
            generateButton,
          ],
        ),
      ),
      child: CButton(
        tooltip: 'Generate Prompt',
        onTap: controller.toggle,
        padding: k8H4VPadding,
        color: isOpen
            ? context.colorScheme.primary
            : PColors.opaqueLightGray.resolveFrom(context),
        child: Icon(
          HugeIcons.strokeRoundedMagicWand01,
          size: 16.0,
          color: isOpen
              ? context.colorScheme.primaryForeground
              : PColors.textGray.resolveFrom(context),
        ),
      ),
    );
  }
}

class _VoiceInputButton extends StatelessWidget {
  const _VoiceInputButton();

  @override
  Widget build(BuildContext context) {
    return VoiceInputButton(
      popoverController: context.watch(),
      onEnd: (text) async {
        final toaster = context.toaster;
        try {
          await context._createTextBlock(null, text);
          toaster.show(
            ShadToast(
              title: const Text('Text added'),
              description: Text(text, maxLines: 5),
            ),
          );
        } catch (e) {
          debugPrint('Error updating block: $e');
          toaster.show(
            ShadToast.destructive(
              title: const Text('Error adding text.'),
              description: Text('$e'),
            ),
          );
        }
      },
    );
  }
}
