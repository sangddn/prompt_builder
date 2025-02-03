part of '../prompt_page.dart';

class _PPCopySection extends StatelessWidget {
  const _PPCopySection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _EditPreviewToggler(),
        Gap(20.0),
        Padding(
          padding: k8HPadding,
          child: _EstimatedTokenCount(),
        ),
        Gap(12.0),
        _ExactTokenCounter(),
        Gap(20.0),
        _CopyPromptButton(),
      ],
    );
  }
}

class _EstimatedTokenCount extends StatelessWidget {
  const _EstimatedTokenCount();

  @override
  Widget build(BuildContext context) {
    return EstimatedTokenCounter(
      countTokens: (context) => context.select(
        (_PromptBlockContents content) => content.values.fold(
          0,
          (acc, block) => acc + (block.textTokenCount ?? 0),
        ),
      ),
    );
  }
}

class _ExactTokenCounter extends StatelessWidget {
  const _ExactTokenCounter();

  @override
  Widget build(BuildContext context) {
    return ExactTokenCounter(
      hasContentChanged: (context, currentContent) =>
          context.selectContent((c) => c != currentContent),
      getContent: () => context.getContent(),
    );
  }
}

class _CopyPromptButton extends StatelessWidget {
  const _CopyPromptButton();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final copySpan = keyboardShortcutSpan(context, true, true, 'C');
    return CopyButton.builder(
      data: () => context.getContent(),
      builder: (context, show, copy) {
        if (context.watch<ValueNotifier<_PromptCopiedEvent?>>().value != null) {
          // Side effect when the prompt is copied via keyboard shortcut
          WidgetsBinding.instance.addPostFrameCallback((_) {
            show(true);
          });
        }
        return CButton(
          tooltip: copySpan,
          tooltipTriggerMode: TooltipTriggerMode.tap,
          padding: k16H8VPadding,
          color: theme.colorScheme.primary,
          onTap: copy,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadImage.square(
                HugeIcons.strokeRoundedCopy01,
                size: 14.0,
                color: theme.colorScheme.primaryForeground,
              ),
              const Gap(8.0),
              Flexible(
                child: Text(
                  'Copy Prompt',
                  style: theme.textTheme.p
                      .copyWith(color: theme.colorScheme.primaryForeground),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EditPreviewToggler extends StatelessWidget {
  const _EditPreviewToggler();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ValueNotifier<_PromptContentViewState>>();
    return CupertinoSlidingSegmentedControl<_PromptContentViewState>(
      children: {
        _PromptContentViewState.edit: PTooltip(
          richMessage: keyboardShortcutSpan(context, true, false, 'E'),
          preferBelow: false,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadImage.square(HugeIcons.strokeRoundedEdit01, size: 14.0),
              Gap(4.0),
              Text('Edit'),
            ],
          ),
        ),
        _PromptContentViewState.preview: PTooltip(
          richMessage: keyboardShortcutSpan(context, true, false, 'E'),
          preferBelow: false,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadImage.square(HugeIcons.strokeRoundedEye, size: 14.0),
              Gap(4.0),
              Text('Preview'),
            ],
          ),
        ),
      },
      groupValue: notifier.value,
      onValueChanged: (v) => v == null ? null : notifier.value = v,
    );
  }
}
