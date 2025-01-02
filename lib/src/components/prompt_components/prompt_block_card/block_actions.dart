part of 'prompt_block_card.dart';

/// Info bar with most common block actions:
/// - Remove
/// - Expand / Collapse
class _BlockInfoBar extends StatelessWidget {
  const _BlockInfoBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BlockMovingActions(),
        const Gap(8.0),
        _ToolBarAction(
          LucideIcons.minus,
          null,
          () async {
            final block = context.block;
            final db = context.db;
            // Only show warning if block has generated content
            final isConfirmed = block.summary == null &&
                    block.transcript == null &&
                    block.caption == null
                ? true
                : await showRemoveBlockWarning(context);
            if (isConfirmed ?? false) {
              await db.deleteBlock(block.id);
            }
          },
          'Remove',
        ),
      ],
    );
  }
}

/// Tool bar with LLM Use Case actions
class _BlockToolBar extends StatelessWidget {
  const _BlockToolBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final useCase in kAllLLMUseCases) _LLMAction(useCase),
          const _UseSummary(),
        ],
      ),
    );
  }
}

class _LLMAction extends StatefulWidget {
  const _LLMAction(this.useCase);

  final LLMUseCase useCase;

  @override
  State<_LLMAction> createState() => _LLMActionState();
}

class _LLMActionState extends AnimatedState<_LLMAction> {
  LLMUseCase get useCase => widget.useCase;
  var _loading = false;

  @override
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.fade(child);

  @override
  Widget buildChild(BuildContext context) {
    final isHovered = context.isHovered();
    if (!isHovered && !_loading) return const SizedBox.shrink();
    return context.selectBlock((b) => useCase.supports(b))
        ? Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _ToolBarAction(
              useCase.icon,
              useCase.actionLabel,
              () async {
                final toaster = context.toaster;
                try {
                  setState(() => _loading = true);
                  await useCase.apply(context.db, context.block);
                } catch (e) {
                  debugPrint('Error using LLM: $e');
                  toaster.show(
                    ShadToast.destructive(
                      title: const Text('Error using LLM.'),
                      description: Text('$e'),
                    ),
                  );
                } finally {
                  maybeSetState(() => _loading = false);
                }
              },
              useCase.name,
              _loading,
            ),
          )
        : const SizedBox.shrink();
  }
}

class _BlockMovingActions extends AnimatedStatelessWidget {
  const _BlockMovingActions();

  @override
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.fade(child);

  @override
  Widget buildChild(BuildContext context) {
    if (!context.isHovered()) return const SizedBox.shrink();
    final callbacks = context.watch<(VoidCallback?, VoidCallback?)>();
    return Row(
      children: [
        _ToolBarAction(LucideIcons.arrowUp, null, callbacks.$1, 'Move up'),
        const Gap(8.0),
        _ToolBarAction(LucideIcons.arrowDown, null, callbacks.$2, 'Move down'),
        const Gap(8.0),
        Builder(
          builder: (context) {
            final isExpanded = context.isExpanded();
            return _ToolBarAction(
              isExpanded
                  ? LucideIcons.chevronsDownUp
                  : LucideIcons.chevronsUpDown,
              null,
              context.toggleExpansion,
              isExpanded ? 'Collapse' : 'Expand',
            );
          },
        ),
        const Gap(8.0),
      ],
    );
  }
}

class _UseSummary extends StatelessWidget {
  const _UseSummary();

  @override
  Widget build(BuildContext context) {
    final hasSummary = context.selectBlock((b) => b.summary != null);
    if (!hasSummary) return const SizedBox.shrink();
    final preferSummary = context.selectBlock((b) => b.preferSummary);
    final side = BorderSide(color: PColors.darkGray.resolveFrom(context));
    return ShadCheckbox(
      value: preferSummary,
      decoration: ShadDecoration(
        border: ShadBorder(
          radius: BorderRadius.circular(6.0),
          top: side,
          bottom: side,
          left: side,
          right: side,
        ),
      ),
      onChanged: (value) {
        context.db.updateBlock(context.block.id, preferSummary: value);
      },
      padding: k4APadding,
      label: const Text('Use summary'),
    );
  }
}

class _TokenCount extends StatefulWidget {
  const _TokenCount();

  @override
  State<_TokenCount> createState() => _TokenCountState();
}

class _TokenCountState extends State<_TokenCount> {
  final _controller = ShadPopoverController();
  (int, String)? _lastCount;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useSummary = context.selectBlock((b) => b.preferSummary);
    final (summaryTokenCount, fullContentTokenCount) = context.selectBlock(
      (b) => (b.summaryTokenCountAndMethod, b.fullContentTokenCountAndMethod),
    );
    final latestCount = useSummary ? summaryTokenCount : fullContentTokenCount;
    if (latestCount != null && latestCount != _lastCount)
      _lastCount = latestCount;
    final isRefreshing = latestCount == null;
    final tokenCount = latestCount ?? _lastCount;
    if (tokenCount == null) return const SizedBox.shrink();
    final savingsPercentage =
        summaryTokenCount != null && fullContentTokenCount != null
            ? ((fullContentTokenCount.$1 - summaryTokenCount.$1) /
                    fullContentTokenCount.$1 *
                    100)
                .toStringAsFixed(1)
            : null;
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
                tokenCount.$1.toString(),
                style: textTheme.large,
                textAlign: TextAlign.start,
              ),
              Text(
                'Estimated ${useSummary ? 'Summary' : 'Full Content'} Tokens',
                style: textTheme.muted,
              ),
              Text(
                tokenCount.$2,
                style: textTheme.muted,
              ),
            ],
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => _controller.show(),
        onExit: (_) => _controller.hide(),
        child: TranslationSwitcher.top(
          layoutBuilder: alignedLayoutBuilder(Alignment.centerLeft),
          child: GrayShimmer(
            key: ValueKey(useSummary),
            enableShimmer: isRefreshing,
            child: Text(
              '~${formatTokenCount(tokenCount.$1)} tokens${useSummary ? ' (-$savingsPercentage%)' : ''}',
              style: context.textTheme.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolBarAction extends StatelessWidget {
  const _ToolBarAction(
    this.icon,
    this.label,
    this.onTap, [
    this.tooltip,
    this.shimmer = false,
  ]);

  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    return CButton(
      tooltip: tooltip,
      onTap: onTap,
      padding: k6APadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.0),
          if (label != null) ...[
            const Gap(4.0),
            GrayShimmer(
              enableShimmer: shimmer,
              child: Text(label!, style: context.textTheme.muted),
            ),
          ],
        ],
      ),
    );
  }
}
