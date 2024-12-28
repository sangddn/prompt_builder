part of '../prompt_page.dart';

class _PPBlockContentScope extends StatefulWidget {
  const _PPBlockContentScope({required this.child});

  final Widget child;

  @override
  State<_PPBlockContentScope> createState() => _PPBlockContentScopeState();
}

class _PPBlockContentScopeState extends State<_PPBlockContentScope>
    with _BlockChangesHandler {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<_PromptBlockContents>.value(value: _contents),
        ProxyProvider<_PromptBlockContents, _PromptCopiableContent>(
          update: (context, contents, _) => _PromptCopiableContent(
            text: contents.values.map((e) => e.text).nonNulls.join('\n\n'),
            summary:
                contents.values.map((e) => e.summary).nonNulls.join('\n\n'),
          ),
        ),
        ProxyProvider2<_PromptBlockList, _PromptBlockContents,
            _TokenCountingState>(
          update: (context, blocks, contents, _) => _TokenCountingState(
            contents.length / blocks.length,
          ),
        ),
      ],
      child: widget.child,
    );
  }
}

// -----------------------------------------------------------------------------
// Handle Block Changes Mixin
// -----------------------------------------------------------------------------

mixin _BlockChangesHandler on State<_PPBlockContentScope> {
  _PromptBlockContents _contents = const IMap.empty();

  void _addContents(List<PromptBlock> newBlocks) {
    Future.wait(
      newBlocks.map((block) async {
        final provider = context.read<ValueNotifier<LLMProvider>>().value;
        final text = block.copyToPrompt();
        final textTokenCount = await text?.let(provider.countTokens);
        final summary = block.copyToPrompt(preferSummary: true);
        final summaryTokenCount = await summary?.let(provider.countTokens);
        return _PromptBlockContent(
          id: block.id,
          text: text,
          summary: summary,
          textTokenCount: textTokenCount?.$1,
          summaryTokenCount: summaryTokenCount?.$1,
          textTokenCountMethod: textTokenCount?.$2,
          summaryTokenCountMethod: summaryTokenCount?.$2,
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
    _contents =
        _contents.removeWhere((id, _) => !blocks.any((b) => b.id == id));
    // Add new blocks
    final diff = blocks.where((b) {
      final prevBlock = _contents[b.id];
      return prevBlock == null ||
          (prevBlock.text != b.textContent && b.textContent != null) ||
          (prevBlock.text != b.transcript && b.transcript != null) ||
          (prevBlock.text != b.caption && b.caption != null) ||
          (prevBlock.summary != b.summary && b.summary != null);
    });
    if (diff.isNotEmpty) {
      _addContents(diff.toList());
    }
  }
}

// -----------------------------------------------------------------------------
// Data class & Typedefs
// -----------------------------------------------------------------------------

typedef _PromptBlockContents = IMap<int, _PromptBlockContent>;
typedef _NodeSelectionCallback = void Function(IndexedFileTree, bool);

@immutable
class _TokenCountingState {
  const _TokenCountingState(this.percentage);
  final double percentage;
  @override
  bool operator ==(Object other) =>
      other is _TokenCountingState && percentage == other.percentage;
  @override
  int get hashCode => percentage.hashCode;
}

@immutable
class _PromptBlockContent {
  const _PromptBlockContent({
    required this.id,
    required this.text,
    required this.summary,
    required this.textTokenCount,
    required this.summaryTokenCount,
    required this.textTokenCountMethod,
    required this.summaryTokenCountMethod,
  });

  final int id;
  final String? text;
  final String? summary;
  final int? textTokenCount;
  final int? summaryTokenCount;
  final String? textTokenCountMethod;
  final String? summaryTokenCountMethod;

  @override
  bool operator ==(Object other) =>
      other is _PromptBlockContent &&
      id == other.id &&
      text == other.text &&
      summary == other.summary &&
      textTokenCount == other.textTokenCount &&
      summaryTokenCount == other.summaryTokenCount &&
      textTokenCountMethod == other.textTokenCountMethod &&
      summaryTokenCountMethod == other.summaryTokenCountMethod;

  @override
  int get hashCode => Object.hash(
        id,
        text,
        summary,
        textTokenCount,
        summaryTokenCount,
        textTokenCountMethod,
        summaryTokenCountMethod,
      );
}

@immutable
class _PromptCopiableContent {
  const _PromptCopiableContent({
    required this.text,
    required this.summary,
  });

  final String text;
  final String summary;

  @override
  bool operator ==(Object other) =>
      other is _PromptCopiableContent &&
      text == other.text &&
      summary == other.summary;

  @override
  int get hashCode => Object.hash(text, summary);
}

// -----------------------------------------------------------------------------
// Extension
// -----------------------------------------------------------------------------

extension _PromptBlockContentExtension on BuildContext {
  String getContent({
    bool listen = false,
    bool preferSummary = false,
  }) {
    final content = Provider.of<_PromptCopiableContent>(this, listen: listen);
    return preferSummary ? content.summary : content.text;
  }
}
