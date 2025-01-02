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
        Gap(20.0),
        _CopyButton(),
      ],
    );
  }
}

class _EstimatedTokenCount extends StatelessWidget {
  const _EstimatedTokenCount();

  @override
  Widget build(BuildContext context) {
    final tokenCount = context.select(
      (_PromptBlockContents content) => content.values.fold(
        0,
        (acc, block) => acc + (block.textTokenCount ?? 0),
      ),
    );
    return Row(
      children: [
        const Expanded(child: Text('Estimated Tokens')),
        _TokenEstimation(tokenCount, true),
      ],
    );
  }
}

class _TokenEstimationProgress extends StatelessWidget {
  const _TokenEstimationProgress(this.isFullContent);

  final bool isFullContent;

  @override
  Widget build(BuildContext context) {
    final numBlocks = context.selectBlocks((bs) => bs.length);
    final percentage = context.watch<_TokenCountingState>().count / numBlocks;
    return TranslationSwitcher.top(
      child: percentage >= 1.0
          ? const SizedBox.shrink()
          : AnimatedCircularProgress(percentage: percentage, size: 20.0),
    );
  }
}

class _TokenEstimation extends StatefulWidget {
  const _TokenEstimation(this.count, this.isFullContent);

  final int count;
  final bool isFullContent;

  @override
  State<_TokenEstimation> createState() => _TokenEstimationState();
}

class _TokenEstimationState extends State<_TokenEstimation> {
  final _controller = ShadPopoverController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadPopover(
      controller: _controller,
      popover: (context) {
        final textTheme = context.textTheme;
        return IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.count.toString(),
                style: textTheme.large,
                textAlign: TextAlign.start,
              ),
              Text(
                'Estimated ${widget.isFullContent ? 'Full Content' : 'Summary'} Tokens',
                style: textTheme.muted,
              ),
            ],
          ),
        );
      },
      child: LongHoverButton(
        onHover: (_) => _controller.show(),
        onExit: (_) => _controller.hide(),
        child: Row(
          children: [
            _TokenEstimationProgress(widget.isFullContent),
            const Gap(4.0),
            Text(
              formatTokenCount(widget.count),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final copySpan = keyboardShortcutSpan(context, true, true, 'C');
    return CopyButton.builder(
      data: () => context.getContent(),
      builder: (context, show, copy) {
        if (context.watch<ValueNotifier<_PromptCopiedEvent?>>().value != null) {
          // Side effect
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
