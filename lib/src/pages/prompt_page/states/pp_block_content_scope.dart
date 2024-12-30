part of '../prompt_page.dart';

class _PPBlockContentScope extends StatelessWidget {
  const _PPBlockContentScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => StateProvider<_TokenCountingState>(
        createInitialValue: (context) => const _TokenCountingState(0),
        child: _BlockChangesHandler(child: child),
      );
}

// -----------------------------------------------------------------------------
// Handle Block Changes
// -----------------------------------------------------------------------------

class _BlockChangesHandler extends StatefulWidget {
  const _BlockChangesHandler({required this.child});

  final Widget child;

  @override
  State<_BlockChangesHandler> createState() => _BlockChangesHandlerState();
}

class _BlockChangesHandlerState extends State<_BlockChangesHandler> {
  _PromptBlockContents _contents = const IMap.empty();

  Future<(String?, int?, String?)> _extractContentAndCountTokens(
    LLMProvider provider,
    PromptBlock block,
  ) async {
    final content = block.copyToPrompt();
    final preferSummary = block.preferSummary;
    if (preferSummary && block.summaryTokenCountAndMethod != null) {
      return (
        content,
        block.summaryTokenCountAndMethod!.$1,
        block.summaryTokenCountAndMethod!.$2
      );
    }
    if (!preferSummary && block.fullContentTokenCountAndMethod != null) {
      return (
        content,
        block.fullContentTokenCountAndMethod!.$1,
        block.fullContentTokenCountAndMethod!.$2
      );
    }
    final count = await content?.let(provider.countTokens);
    if (mounted) {
      context.db.updateBlock(
        block.id,
        fullContentTokenCountAndMethod: preferSummary ? null : count,
        summaryTokenCountAndMethod: preferSummary ? count : null,
      );
    }
    return (content, count?.$1, count?.$2);
  }

  Future<void> _upsertContents(List<PromptBlock> newBlocks) async {
    await Future.wait(
      newBlocks.map((block) async {
        final countingNotifier = context.countingNotifier;
        final provider = context.read<ValueNotifier<LLMProvider>>().value;
        final text = await _extractContentAndCountTokens(provider, block);
        countingNotifier.value = countingNotifier.value.increment();
        return _PromptBlockContent(
          id: block.id,
          text: text.$1,
          textTokenCount: text.$2,
          textTokenCountMethod: text.$3,
        );
      }),
    ).then(
      (contents) => maybeSetState(
        () => _contents =
            _contents.addEntries(contents.map((c) => MapEntry(c.id, c))),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final blocks = context.watch<_PromptBlockList>();
    // Remove blocks that are no longer in the list
    int numRemoved = 0;
    for (final id in _contents.keys) {
      if (!blocks.any((b) => b.id == id)) {
        _contents = _contents.remove(id);
        numRemoved++;
      }
    }
    // Add new and update changed blocks
    int numChanged = 0;
    final diff = <PromptBlock>[];
    for (final block in blocks) {
      final prevBlock = _contents[block.id];
      if (prevBlock == null) {
        diff.add(block);
      } else if (prevBlock.text != block.copyToPrompt() ||
          (!block.preferSummary && block.fullContentTokenCount == null) ||
          (block.preferSummary && block.summaryTokenCount == null)) {
        diff.add(block);
        numChanged++;
      }
    }
    if (diff.isNotEmpty) {
      final countingNotifier = context.countingNotifier;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        countingNotifier.value = _TokenCountingState(
          countingNotifier.value.count - numChanged - numRemoved,
        );
      });
      _upsertContents(diff.toList());
    }
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<_PromptBlockContents>.value(value: _contents),
          ProxyProvider<_PromptBlockContents, _PromptCopiableContent>(
            update: (context, contents, _) => _PromptCopiableContent(
              contents.values.map((e) => e.text).nonNulls.join('\n\n'),
            ),
          ),
        ],
        child: widget.child,
      );
}

// -----------------------------------------------------------------------------
// Data class & Typedefs
// -----------------------------------------------------------------------------

typedef _PromptBlockContents = IMap<int, _PromptBlockContent>;

/// A state that holds the # of blocks completed for the token counting process.
@immutable
class _TokenCountingState {
  const _TokenCountingState(this.count);
  final int count;

  _TokenCountingState increment() => _TokenCountingState(count + 1);

  @override
  bool operator ==(Object other) =>
      other is _TokenCountingState && count == other.count;

  @override
  int get hashCode => count.hashCode;

  @override
  String toString() => 'TokenCountingState(count: $count)';
}

@immutable
class _PromptBlockContent {
  const _PromptBlockContent({
    required this.id,
    required this.text,
    required this.textTokenCount,
    required this.textTokenCountMethod,
  });

  final int id;
  final String? text;
  final int? textTokenCount;
  final String? textTokenCountMethod;

  @override
  bool operator ==(Object other) =>
      other is _PromptBlockContent &&
      id == other.id &&
      text == other.text &&
      textTokenCount == other.textTokenCount &&
      textTokenCountMethod == other.textTokenCountMethod;

  @override
  int get hashCode => Object.hash(
        id,
        text,
        textTokenCount,
        textTokenCountMethod,
      );
}

@immutable
class _PromptCopiableContent {
  const _PromptCopiableContent(this.text);

  final String text;

  @override
  bool operator ==(Object other) =>
      other is _PromptCopiableContent && text == other.text;

  @override
  int get hashCode => text.hashCode;
}

// -----------------------------------------------------------------------------
// Extension
// -----------------------------------------------------------------------------

extension _PromptBlockContentExtension on BuildContext {
  ValueNotifier<_TokenCountingState> get countingNotifier =>
      read<ValueNotifier<_TokenCountingState>>();

  String getContent({bool listen = false}) {
    final content = Provider.of<_PromptCopiableContent>(this, listen: listen);
    return content.text;
  }
}
