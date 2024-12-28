part of '../prompt_page.dart';

class _PPCopySection extends StatelessWidget {
  const _PPCopySection();

  @override
  Widget build(BuildContext context) {
    return StateProvider<_CopySectionType>(
      createInitialValue: (_) => _CopySectionType.fullContent,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EditPreviewToggler(),
          Gap(20.0),
          Padding(
            padding: k8HPadding,
            child: _EstimatedTokenCount(),
          ),
          Gap(12.0),
          _PreferSummaryCheckbox(),
          Gap(20.0),
          _CopyButton(),
        ],
      ),
    );
  }
}

enum _CopySectionType {
  fullContent,
  summary,
}

class _EstimatedTokenCount extends StatelessWidget {
  const _EstimatedTokenCount();

  @override
  Widget build(BuildContext context) {
    final (fullContentCount, summaryCount) = context.select(
      (_PromptBlockContents content) => content.values.fold(
        (0, 0),
        (acc, block) => (
          acc.$1 + (block.textTokenCount ?? 0),
          acc.$2 + (block.summaryTokenCount ?? 0)
        ),
      ),
    );
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Text('Full Content')),
            _TokenEstimation(fullContentCount, 'Full Content'),
          ],
        ),
        Row(
          children: [
            const Expanded(
              child: Row(
                children: [
                  Text('Summary'),
                  _SummaryExplanation(),
                ],
              ),
            ),
            _TokenEstimation(summaryCount, 'Summary'),
          ],
        ),
      ],
    );
  }
}

class _TokenEstimationProgress extends StatelessWidget {
  const _TokenEstimationProgress();

  @override
  Widget build(BuildContext context) {
    final percentage = context.watch<_TokenCountingState>().percentage;
    return TranslationSwitcher.top(
      duration: Effects.shortDuration,
      child: percentage == 1.0
          ? const SizedBox.shrink()
          : AnimatedCircularProgress(percentage: percentage, size: 28.0),
    );
  }
}

class _TokenEstimation extends StatefulWidget {
  const _TokenEstimation(this.count, this.kind);

  final int count;
  final String kind;

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
                'Estimated ${widget.kind} Tokens',
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
            const _TokenEstimationProgress(),
            Text(
              _formatNumber(widget.count),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatNumber(int number) {
  if (number < 1000) return number.toString();
  if (number < 1000000) {
    final k = (number / 1000).toStringAsFixed(1);
    return '${k}k';
  }
  final m = (number / 1000000).toStringAsFixed(1);
  return '${m}M';
}

class _PreferSummaryCheckbox extends StatelessWidget {
  const _PreferSummaryCheckbox();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ValueNotifier<_CopySectionType>>();
    return ShadCheckbox(
      value: notifier.value == _CopySectionType.summary,
      onChanged: (v) => notifier.value =
          v ? _CopySectionType.summary : _CopySectionType.fullContent,
      label: const Text('Prefer summary'),
      sublabel: const Text(
        'Copy summaries instead of full content where available.',
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton();

  @override
  Widget build(BuildContext context) {
    final isSummary =
        context.watch<_CopySectionType>() == _CopySectionType.summary;
    return CopyButton(
      data: () => context.getContent(preferSummary: isSummary),
      backgroundColor: context.colorScheme.primary,
      foregroundColor: context.colorScheme.primaryForeground,
      label: isSummary ? 'Copy Summary' : 'Copy Prompt',
    );
  }
}

class _SummaryExplanation extends StatefulWidget {
  const _SummaryExplanation();
  @override
  State<_SummaryExplanation> createState() => _SummaryExplanationState();
}

class _SummaryExplanationState extends State<_SummaryExplanation> {
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
        return SizedBox(
          width: 288,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Summary',
                style: textTheme.muted,
              ),
              const Gap(4.0),
              Text(
                'Some content such as web pages, text files, and audio transcripts can be summarized '
                'before being injected into the prompt. This can save tokens and improve performance.',
                style: textTheme.p,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        );
      },
      child: MouseRegion(
        onHover: (_) => _controller.show(),
        onExit: (_) => _controller.hide(),
        child: const ShadButton.ghost(
          padding: k8H4VPadding,
          size: ShadButtonSize.sm,
          child: ShadImage.square(
            CupertinoIcons.question_circle,
            size: 16.0,
          ),
        ),
      ),
    );
  }
}

class _EditPreviewToggler extends StatelessWidget {
  const _EditPreviewToggler();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ValueNotifier<_PromptContentViewState>>();
    return CupertinoSlidingSegmentedControl<_PromptContentViewState>(
      children: const {
        _PromptContentViewState.edit: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadImage.square(HugeIcons.strokeRoundedEdit01, size: 14.0),
            Gap(4.0),
            Text('Edit'),
          ],
        ),
        _PromptContentViewState.preview: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadImage.square(HugeIcons.strokeRoundedEye, size: 14.0),
            Gap(4.0),
            Text('Preview'),
          ],
        ),
      },
      groupValue: notifier.value,
      onValueChanged: (v) => v == null ? null : notifier.value = v,
    );
  }
}
