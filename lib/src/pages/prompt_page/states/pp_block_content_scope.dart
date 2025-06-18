part of '../prompt_page.dart';

class _PPBlockContentScope extends StatefulWidget {
  const _PPBlockContentScope({required this.child});

  final Widget child;

  @override
  State<_PPBlockContentScope> createState() => _PPBlockContentScopeState();
}

class _PPBlockContentScopeState extends State<_PPBlockContentScope> {
  _PromptBlockContents _contents = const IMap.empty();

  (String?, int?, String?) _extractContentAndCountTokens(
    LLMProvider provider,
    PromptBlock block,
  ) {
    final content = block.copyToPrompt();
    final preferSummary = block.preferSummary;
    if (preferSummary && block.summaryTokenCountAndMethod != null) {
      return (
        content,
        block.summaryTokenCountAndMethod!.$1,
        block.summaryTokenCountAndMethod!.$2,
      );
    }
    if (!preferSummary && block.fullContentTokenCountAndMethod != null) {
      return (
        content,
        block.fullContentTokenCountAndMethod!.$1,
        block.fullContentTokenCountAndMethod!.$2,
      );
    }
    final count = content?.let(provider.estimateTokens);
    if (mounted) {
      context.db.updateBlock(
        block.id,
        fullContentTokenCountAndMethod: preferSummary ? null : count,
        summaryTokenCountAndMethod: preferSummary ? count : null,
      );
    }
    return (content, count?.$1, count?.$2);
  }

  void _upsertContents(List<PromptBlock> newBlocks) {
    final contents = newBlocks.map((block) {
      final provider = context.read<ValueNotifier<LLMProvider>>().value;
      final text = _extractContentAndCountTokens(provider, block);
      return _PromptBlockContent(
        id: block.id,
        text: text.$1,
        textTokenCount: text.$2,
        textTokenCountMethod: text.$3,
      );
    });
    setState(
      () =>
          _contents = _contents.addEntries(
            contents.map((c) => MapEntry(c.id, c)),
          ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final blocks = context.watch<_PromptBlockList>();
    // Remove blocks that are no longer in the list
    for (final id in _contents.keys) {
      if (!blocks.any((b) => b.id == id)) {
        _contents = _contents.remove(id);
      }
    }
    // Add new and update changed blocks
    final diff = <PromptBlock>[];
    for (final block in blocks) {
      final prevBlock = _contents[block.id];
      if (prevBlock == null) {
        diff.add(block);
      } else if (prevBlock.text != block.copyToPrompt() ||
          (!block.preferSummary && block.fullContentTokenCount == null) ||
          (block.preferSummary && block.summaryTokenCount == null)) {
        diff.add(block);
      }
    }
    if (diff.isNotEmpty) {
      _upsertContents(diff.toList());
    }
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider<_PromptBlockContents>.value(value: _contents),
      ProxyProvider2<
        _PromptBlockList,
        _PromptBlockContents,
        _PromptCopiableContent
      >(
        update:
            (context, blocks, contents, _) => _PromptCopiableContent(
              blocks.map((b) => contents[b.id]?.text).nonNulls.join('\n\n'),
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
  int get hashCode =>
      Object.hash(id, text, textTokenCount, textTokenCountMethod);
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
  String getContent({bool listen = false}) {
    final content = Provider.of<_PromptCopiableContent>(this, listen: listen);
    return content.text;
  }

  T selectContent<T>(T Function(String) fn) =>
      select((_PromptCopiableContent c) => fn(c.text));
}
