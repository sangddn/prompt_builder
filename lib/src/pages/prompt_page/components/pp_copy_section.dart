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
        _CountTokensButton(),
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
    final tokenCount = context.select(
      (_PromptBlockContents content) => content.values.fold(
        0,
        (acc, block) => acc + (block.textTokenCount ?? 0),
      ),
    );
    return Row(
      children: [
        Expanded(child: Text('Estimated Tokens', style: context.textTheme.p)),
        _TokenEstimation(tokenCount, true),
      ],
    );
  }
}

class _TokenEstimation extends StatelessWidget {
  const _TokenEstimation(this.count, this.isFullContent);

  final int count;
  final bool isFullContent;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => ShadPopoverController(),
      builder: (context, child) {
        final controller = context.read<ShadPopoverController>();
        return ShadPopover(
          controller: controller,
          popover: (context) {
            final textTheme = context.textTheme;
            return IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    count.toString(),
                    style: textTheme.large,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    'Estimated ${isFullContent ? 'Full Content' : 'Summary'} Tokens',
                    style: textTheme.muted,
                  ),
                ],
              ),
            );
          },
          child: MouseRegion(
            onHover: (_) => controller.show(),
            onExit: (_) => controller.hide(),
            child: child,
          ),
        );
      },
      child: Text(
        formatTokenCount(count),
        style: context.textTheme.small.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CountTokensButton extends StatefulWidget {
  const _CountTokensButton();

  @override
  State<_CountTokensButton> createState() => _CountTokensButtonState();
}

class _CountTokensButtonState extends State<_CountTokensButton> {
  final _controller = ShadPopoverController();
  Future<Map<LLMProvider, (int, String)?>>? _countFuture;
  String? _content;
  bool _hasContentChanged = false;

  void _count() {
    setState(
      () {
        _content = context.getContent();
        _hasContentChanged = false;
        final futures = kAllLLMProviders.map((provider) {
          try {
            return provider.countTokens(_content!);
          } on ApiKeyNotSetException {
            // ignore: avoid_redundant_argument_values
            return Future.value(null);
          } on HttpException {
            // ignore: avoid_redundant_argument_values
            return Future.value(null);
          }
        });
        _countFuture = Future.wait(futures).then(
          (results) => Map.fromIterables(kAllLLMProviders, results),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    if (!_hasContentChanged) {
      _hasContentChanged = context.selectContent((c) => c != _content);
    }
    return AnimatedFutureBuilder(
      future: _countFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final counts = snapshot.data;
        return ShadPopover(
          controller: _controller,
          popover: (_) =>
              _ExactTokenCounts(counts, isLoading, _hasContentChanged),
          child: MouseRegion(
            onHover: (_) => _controller.show(),
            onExit: (_) => _controller.hide(),
            child: CButton(
              tooltip: null,
              tooltipTriggerMode: TooltipTriggerMode.tap,
              padding: k16H4VPadding,
              onTap: _count,
              child: SizedBox(
                width: double.infinity,
                child: TranslationSwitcher.top(
                  child: Text(
                    counts != null && !_hasContentChanged
                        ? 'Exact Counts'
                        : 'Count Exact',
                    style: theme.textTheme.muted,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    key: ValueKey(counts != null && !_hasContentChanged),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExactTokenCounts extends StatelessWidget {
  const _ExactTokenCounts(this.counts, this.isLoading, this.hasContentChanged);

  final Map<LLMProvider, (int, String)?>? counts;
  final bool isLoading;
  final bool hasContentChanged;

  @override
  Widget build(BuildContext context) {
    final counts = this.counts;
    if (counts == null || counts.isEmpty || isLoading) {
      return SizedBox(
        width: 200.0,
        height: 48.0,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator.adaptive()
              : Padding(
                  padding: k8APadding,
                  child: Text(
                    'Count exact tokens with Tiktoken or API.',
                    style: context.textTheme.small,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      );
    }
    final textTheme = context.textTheme;
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final MapEntry(key: provider, :value) in counts.entries)
            Row(
              children: [
                Text(value?.$2 ?? provider.name),
                const Spacer(),
                const Gap(8.0),
                if (value != null)
                  Text(
                    '${value.$1}',
                    style: textTheme.list.copyWith(fontWeight: FontWeight.bold),
                  )
                else
                  Text('n/a', style: textTheme.muted),
              ],
            ),
          if (hasContentChanged) ...[
            const Gap(4.0),
            Text(
              'May be outdated. Recount to update.',
              style: textTheme.muted,
            ),
          ],
        ],
      ),
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
