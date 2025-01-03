part of '../prompt_page.dart';

/// A widget that provides block-related data and functionality for a specific prompt.
///
/// This scope manages:
/// - List of blocks associated with the prompt
/// - Unique keys for each block
/// - Block reordering functionality
/// - Local file and folder selection
class _PPBlockScope extends StatefulWidget {
  const _PPBlockScope({
    required this.promptId,
    required this.child,
  });

  /// The ID of the prompt this scope is associated with
  final int promptId;

  /// The child widget that will have access to this scope's providers
  final Widget child;

  @override
  State<_PPBlockScope> createState() => _PPBlockScopeState();
}

class _PPBlockScopeState extends State<_PPBlockScope> {
  final _blockKeys = <int, GlobalKey>{};

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<_PromptBlockList>(
          initialData: const IList.empty(),
          create: (context) => context.db
              .streamBlocksByPrompt(widget.promptId)
              .map((e) => IList(e)),
        ),
        ProxyProvider<_PromptBlockList, _BlockKeyList>(
          update: (BuildContext context, _PromptBlockList blocks, _) => blocks
              .map(
                (b) => (b.id, _blockKeys.putIfAbsent(b.id, () => GlobalKey())),
              )
              .toIList(),
        ),
        ProxyProvider<_PromptBlockList, _BlockReorderCallback>(
          update: (context, blocks, _) =>
              (oldIndex, newIndex) => context.db.reorderBlock(
                    promptId: widget.promptId,
                    blockId: blocks[oldIndex].id,
                    newIndex: newIndex,
                  ),
        ),
      ],
      child: widget.child,
    );
  }
}

// -----------------------------------------------------------------------------
// Providers & Typedefs
// -----------------------------------------------------------------------------

typedef _PromptBlockList = IList<PromptBlock>;
typedef _BlockKeyList = IList<(int, GlobalKey)>;
typedef _BlockReorderCallback = void Function(int oldIndex, int newIndex);

// -----------------------------------------------------------------------------
// Extensions
// -----------------------------------------------------------------------------

/// Extension methods for accessing block-related data from the BuildContext
extension _PromptBlockScopeExtension on BuildContext {
  /// Returns the current list of prompt blocks
  _PromptBlockList get promptBlocks => read();

  /// Watches and returns the list of block keys
  _BlockKeyList watchBlockKeys() => watch();

  /// Applies a transformation function to the block list and watches for changes
  T selectBlocks<T>(T Function(_PromptBlockList) fn) => select(fn);

  /// Watches and returns a specific block by ID
  PromptBlock? watchBlock(int id) => selectBlocks(
        (bs) => bs.firstWhereOrNull((b) => b.id == id),
      );

  /// Creates a new text block for the prompt at the given index and returns its
  /// ID. The new block will occupy the given index in the new list.
  ///
  /// If the index is 0, the new block will be inserted at the beginning of the
  /// list. If the index is the currently last index (n_old - 1), the new block
  /// will be inserted right before the last block.
  Future<int?> createTextBlockAtIndex(
    int index, {
    String? displayName,
    String? textContent,
  }) async {
    final promptId = prompt?.id;
    if (promptId == null) return null;
    if (index < 0) throw StateError('New index must be non-negative.');
    if (index == 0) {
      final prevSortOrder = promptBlocks.firstOrNull?.sortOrder;
      final sortOrder = (prevSortOrder ?? 10e6) / 2;
      return db.createBlock(
        promptId: promptId,
        blockType: BlockType.text,
        displayName: displayName,
        textContent: textContent,
        sortOrder: sortOrder,
      );
    }
    final currentLength = promptBlocks.length;
    if (index >= currentLength) {
      final currentLastSortOrder = promptBlocks.lastOrNull?.sortOrder;
      final sortOrder = (currentLastSortOrder ?? 10e6) * 2;
      return db.createBlock(
        promptId: promptId,
        blockType: BlockType.text,
        displayName: displayName,
        textContent: textContent,
        sortOrder: sortOrder,
      );
    }
    final prevSortOrder = promptBlocks[index - 1].sortOrder;
    final nextSortOrder = promptBlocks[index].sortOrder;
    final sortOrder = (prevSortOrder + nextSortOrder) / 2;
    return db.createBlock(
      promptId: promptId,
      blockType: BlockType.text,
      displayName: displayName,
      textContent: textContent,
      sortOrder: sortOrder,
    );
  }
}
