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
  final _blockKeys = <int, UniqueKey>{};

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
                (b) => (b.id, _blockKeys.putIfAbsent(b.id, () => UniqueKey())),
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
        ProxyProvider<_PromptBlockList, _SelectedFilePaths>(
          update: (context, blocks, _) =>
              blocks.map((b) => b.filePath).nonNulls.toISet(),
        ),
        Provider<_NodeSelectionCallback>(create: _getNodeSelectionHandler),
      ],
      child: widget.child,
    );
  }
}

// -----------------------------------------------------------------------------
// Handle File/Folder Selection Mixin
// -----------------------------------------------------------------------------

_NodeSelectionCallback _getNodeSelectionHandler(BuildContext context) => (
      IndexedFileTree node,
      bool isSelected,
    ) async {
      final item = node.data!;
      final path = item.path;
      // Deselect the file, or all files in the folder (recursively)
      if (!isSelected) {
        final blocks = context.promptBlocks;
        final blocksToRemove = blocks
            .where((b) => b.filePath?.startsWith(path) ?? false)
            .map((b) => b.id)
            .toList();
        await context.db.deleteBlocks(blocksToRemove);
        return;
      }
      // Select the file, or all files in the folder (recursively)
      final allFilePaths = <String>[];
      final nodesToVisit = <IndexedFileTree>[node];
      while (nodesToVisit.isNotEmpty) {
        final node = nodesToVisit.removeLast();
        final item = node.data!;
        final path = item.path;
        if (item.isDirectory) {
          nodesToVisit.addAll(node.children.cast());
        } else {
          allFilePaths.add(path);
        }
      }
      await context.db.createBlocksFromFiles(
        allFilePaths,
        promptId: context.prompt!.id,
      );
    };

// -----------------------------------------------------------------------------
// Providers & Typedefs
// -----------------------------------------------------------------------------

typedef _PromptBlockList = IList<PromptBlock>;
typedef _BlockKeyList = IList<(int, Key)>;
typedef _BlockReorderCallback = void Function(int oldIndex, int newIndex);
typedef _SelectedFilePaths = ISet<String>;

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

  /// Applies a transformation function to a specific block and watches for changes
  T selectBlock<T>(int id, T Function(PromptBlock?) fn) => selectBlocks(
        (bs) => fn(bs.firstWhereOrNull((b) => b.id == id)),
      );

  /// Counts how many selected files start with the given file path
  int countSelection(String filePath) => select(
        (_SelectedFilePaths s) => s.where((e) => e.startsWith(filePath)).length,
      );

  /// Handles the selection of a file or folder
  void handleNodeSelection(IndexedFileTree node, bool isSelected) =>
      read<_NodeSelectionCallback>()(node, isSelected);
}
