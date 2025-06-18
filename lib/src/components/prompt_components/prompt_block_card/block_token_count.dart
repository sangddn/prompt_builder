part of 'prompt_block_card.dart';

/// A widget that displays the token count for either the summary or full content
/// of a prompt block. It handles both the display and loading states with a
/// debounced refresh indicator.
class _TokenCount extends StatefulWidget {
  const _TokenCount();

  @override
  State<_TokenCount> createState() => _TokenCountState();
}

class _TokenCountState extends State<_TokenCount> {
  final _controller = ShadPopoverController();

  /// Caches the last valid token count to prevent flickering during updates
  (int, String)? _lastCount;

  /// Timer used to debounce the refresh state
  Timer? _refreshTimer;

  /// Indicates whether the token count is being recalculated
  /// Only set to true after a 50ms delay if the count is still null
  bool _isRefreshing = false;

  @override
  void dispose() {
    _refreshTimer?.cancel();
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

    if (latestCount != null && latestCount != _lastCount) {
      _lastCount = latestCount;
      _refreshTimer?.cancel();
      _isRefreshing = false;
    } else if (latestCount == null && !_isRefreshing) {
      _refreshTimer?.cancel();
      _refreshTimer = Timer(const Duration(milliseconds: 50), () {
        if (context.block.effectiveTokenCountAndMethod == null) {
          maybeSetState(() => _isRefreshing = true);
        }
      });
    }

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
              Text(tokenCount.$2, style: textTheme.muted),
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
            enableShimmer: _isRefreshing,
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
