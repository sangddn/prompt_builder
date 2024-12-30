part of '../prompt_page.dart';

class _PPFileTreeScope extends StatefulWidget {
  const _PPFileTreeScope({required this.child});

  final Widget child;

  @override
  State<_PPFileTreeScope> createState() => _PPFileTreeScopeState();
}

class _PPFileTreeScopeState extends State<_PPFileTreeScope> {
  // Tree - File paths - Folder paths
  (IndexedFileTree, List<String>, List<String>)? _tree;

  void _onTreeReady(
    IndexedFileTree tree,
    List<String> filePaths,
    List<String> folderPaths,
  ) =>
      setState(() => _tree = (tree, filePaths, folderPaths));

  /// {@macro path_search_callback}
  Future<List<(String, String, bool)>> _searchPaths(
    String query,
  ) async {
    final results = await fuzzySearchAsync(
      [
        ...?_tree?.$2,
        ...?_tree?.$3.map((folder) => '//$folder'),
      ],
      query,
    );
    return results.map((result) {
      final isDirectory = result.startsWith('//');
      final p = isDirectory ? result.substring(2) : result;
      return (
        p,
        path.relative(p, from: context.prompt?.folderPath),
        isDirectory
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider<_PromptBlockList, _SelectedFilePaths>(
          update: (context, blocks, _) =>
              blocks.map((b) => b.filePath).nonNulls.toISet(),
        ),
        Provider<_NodeSelectionCallback>.value(
          value: _getNodeSelectionHandler(context, filePaths: _tree?.$2),
        ),
        Provider<_TreeReadyCallback>.value(value: _onTreeReady),
        Provider<_FileAndFolderPaths>.value(
          value: (ISet(_tree?.$2), ISet(_tree?.$3)),
        ),
        Provider<_PathSearchCallback>.value(value: _searchPaths),
      ],
      child: widget.child,
    );
  }
}

// -----------------------------------------------------------------------------
// Typedefs
// -----------------------------------------------------------------------------

typedef _SelectedFilePaths = ISet<String>;
typedef _NodeSelectionCallback = void Function(
  String fullPath,
  bool isSelected,
);
typedef _TreeReadyCallback = void Function(
  IndexedFileTree tree,
  List<String> filePaths,
  List<String> folderPaths,
);

/// Function signature for the search callback.
/// {@template path_search_callback}
/// Takes a query and returns a list of tuples,
/// where the first element is the full path, the second element is the relative
/// path from the prompt's folder path, and the third element is a boolean
/// indicating whether the path is a directory.
/// {@endtemplate}
typedef _PathSearchCallback
    = Future<List<(String fullPath, String relativePath, bool isDirectory)>>
        Function(String);

/// Signature for the file and folder paths.
typedef _FileAndFolderPaths = (ISet<String>, ISet<String>);

// -----------------------------------------------------------------------------
// Extensions
// -----------------------------------------------------------------------------

extension _PPFileTreeScopeExtension on BuildContext {
  /// Counts how many selected files start with the given file path
  int countSelection(String filePath) => select(
        (_SelectedFilePaths s) => s.where((e) => e.startsWith(filePath)).length,
      );

  /// Handles the selection of a file or folder
  void handleNodeSelection(IndexedFileTree node, bool isSelected) =>
      read<_NodeSelectionCallback>()(node.data!.path, isSelected);
}

// -----------------------------------------------------------------------------
// Utils
// -----------------------------------------------------------------------------

/// Handles file/folder de-/selection
_NodeSelectionCallback _getNodeSelectionHandler(
  BuildContext context, {
  bool reloadNode = false,
  List<String>? filePaths,
}) =>
    (
      String fullPath,
      bool isSelected,
    ) async {
      // Deselect the file, or all files in the folder (recursively)
      if (!isSelected) {
        final blocks = context.promptBlocks;
        final blocksToRemove = blocks
            .where((b) => b.filePath?.startsWith(fullPath) ?? false)
            .map((b) => b.id)
            .toList();
        await context.db.deleteBlocks(blocksToRemove);
        return;
      }
      var allFilePaths = <String>[];
      // Select the file, or all files in the folder (recursively)
      if (reloadNode) {
        allFilePaths = await compute(_loadFilePaths, fullPath);
      } else {
        allFilePaths =
            filePaths?.where((e) => e.startsWith(fullPath)).toList() ?? [];
      }
      if (!context.mounted) return;
      await context.db.createBlocksFromFiles(
        allFilePaths,
        promptId: context.prompt!.id,
      );
    };

/// Loads all file paths that are children of the given file path
List<String> _loadFilePaths(String givenPath) {
  final isDirectory = FileSystemEntity.isDirectorySync(givenPath);
  if (!isDirectory) return [givenPath];
  final dir = Directory(givenPath);
  return dir.listSync().map((e) => e.path).toList();
}
