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

  void _updateTreeAndPaths(
    IndexedFileTree tree,
    List<String> filePaths,
    List<String> folderPaths,
  ) => maybeSetState(() => _tree = (tree, filePaths, folderPaths));

  void _handleEntityEvent(final FileSystemEvent event) {
    final tree = _tree;
    if (tree == null) return;
    switch ((event.isDirectory, event)) {
      case (_, FileSystemModifyEvent()):
        return;
      case (true, FileSystemCreateEvent()):
        maybeSetState(
          () => _tree = (tree.$1, tree.$2, tree.$3..add(event.path)),
        );
      case (true, FileSystemDeleteEvent()):
        maybeSetState(
          () => _tree = (tree.$1, tree.$2, tree.$3..remove(event.path)),
        );
      case (true, FileSystemMoveEvent()):
        maybeSetState(
          () =>
              _tree = (
                tree.$1,
                tree.$2,
                tree.$3
                  ..remove(event.path)
                  ..add((event as FileSystemMoveEvent).destination ?? '')
                  ..remove(''),
              ),
        );
      case (false, FileSystemCreateEvent()):
        maybeSetState(
          () => _tree = (tree.$1, tree.$2..add(event.path), tree.$3),
        );
      case (false, FileSystemDeleteEvent()):
        maybeSetState(
          () => _tree = (tree.$1, tree.$2..remove(event.path), tree.$3),
        );
      case (false, FileSystemMoveEvent()):
        maybeSetState(
          () =>
              _tree = (
                tree.$1,
                tree.$2
                  ..remove(event.path)
                  ..add((event as FileSystemMoveEvent).destination ?? '')
                  ..remove(''),
                tree.$3,
              ),
        );
    }
  }

  /// {@macro pages.prompt_page.path_search_callback}
  Future<List<_PathSearchResult>> _searchPaths(String query) async {
    final results = await fuzzySearchAsync([
      ...?_tree?.$2,
      ...?_tree?.$3.map((folder) => '//$folder'),
    ], query);
    return results.map((result) {
      final isDirectory = result.startsWith('//');
      final p = isDirectory ? result.substring(2) : result;
      return (
        p,
        path.relative(p, from: context.prompt?.folderPath),
        isDirectory,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider<_PromptBlockList, _SelectedFilePaths>(
          update:
              (context, blocks, _) =>
                  blocks.map((b) => b.filePath).nonNulls.toISet(),
        ),
        Provider<_FileAndFolderPaths>.value(
          value: (ISet(_tree?.$2), ISet(_tree?.$3)),
        ),
        Provider<_PathSearchCallback>.value(value: _searchPaths),
        ChangeNotifierProvider<_FolderPathNotifier>(
          create:
              (context) =>
                  createFolderPathNotifier(context, context.prompt?.folderPath),
        ),
        ChangeNotifierProvider<_IgnorePatternsNotifier>(
          create:
              (context) => createIgnorePatternsNotifier(
                context,
                context.prompt?.ignorePatterns,
              ),
        ),
      ],
      child: NotificationListener<FileTreeNotification>(
        onNotification: (n) {
          switch (n) {
            case NodeSelectionNotification():
              _handleNodeSelection(
                context,
                fullPath: n.path,
                isSelected: n.isSelected,
                filePaths: _tree?.$2,
              );
              return true;
            case TreeReadyNotification():
              _updateTreeAndPaths(n.tree, n.filePaths, n.folderPaths);
              return true;
            case EntityEventNotification():
              _handleEntityEvent(n.event);
              return true;
          }
        },
        child: widget.child,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Typedefs
// -----------------------------------------------------------------------------

typedef _SelectedFilePaths = ISet<String>;

typedef _PathSearchResult =
    (String fullPath, String relativePath, bool isDirectory);

/// Type signature of the search results.
/// The first element is the full path, the second element is the relative path,
/// and the third element is a boolean indicating whether the path is a directory.
typedef _PathSearchResults = IList<_PathSearchResult>;

/// Function signature for the search callback.
/// {@template pages.prompt_page.path_search_callback}
/// Takes a query and returns a list of tuples,
/// where the first element is the full path, the second element is the relative
/// path from the prompt's folder path, and the third element is a boolean
/// indicating whether the path is a directory.
/// {@endtemplate}
typedef _PathSearchCallback = Future<List<_PathSearchResult>> Function(String);

/// Signature for the file and folder paths.
typedef _FileAndFolderPaths = (ISet<String>, ISet<String>);

/// Signature for the folder path notifier.
typedef _FolderPathNotifier = ValueNotifier<String?>;

/// Signature for the notifier for ignore patterns.
typedef _IgnorePatternsNotifier = ValueNotifier<IList<String>>;

/// Creates a [ValueNotifier] for the folder path associated with the prompt.
/// It automatically updates the prompt in the database when the folder path
/// changes.
ValueNotifier<String?> createFolderPathNotifier(
  BuildContext context,
  String? folderPath,
) {
  final notifier = ValueNotifier(folderPath);
  notifier.addListener(() {
    context.db.updatePrompt(context.prompt!.id, folderPath: notifier.value);
  });
  return notifier;
}

/// Creates a [ValueNotifier] for ignore patterns associated with the prompt.
/// It automatically updates the prompt in the database when the ignore
/// patterns change.
ValueNotifier<IList<String>> createIgnorePatternsNotifier(
  BuildContext context,
  String? ignorePatterns,
) {
  final notifier = ValueNotifier(
    IList(
      ignorePatterns?.split('\n').where((p) => p.trim().isNotEmpty).toList(),
    ),
  );
  notifier.addListener(() {
    context.db.updatePrompt(
      context.prompt!.id,
      ignorePatterns: notifier.value.join('\n'),
    );
  });
  return notifier;
}

// -----------------------------------------------------------------------------
// Extensions
// -----------------------------------------------------------------------------

extension _PPFileTreeScopeExtension on BuildContext {
  ValueNotifier<String?> get folderNotifier => read<ValueNotifier<String?>>();
  // ValueNotifier<IList<String>> get ignorePatternsNotifier =>
  //     read<ValueNotifier<IList<String>>>();

  String? watchFolderPath() => watch<ValueNotifier<String?>>().value;
  IList<String> watchIgnorePatterns() =>
      watch<ValueNotifier<IList<String>>>().value;

  bool isAnyFolderSelected() =>
      select((ValueNotifier<String?> n) => n.value != null);

  /// Pick a folder
  Future<void> pickFolder() async {
    final notifier = folderNotifier;
    final String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath(initialDirectory: notifier.value);
    if (selectedDirectory != null) {
      notifier.value = selectedDirectory;
    }
  }

  /// Counts how many selected files start with the given file path
  int countSelection(String filePath) => select(
    (_SelectedFilePaths s) => s.where((e) => e.startsWith(filePath)).length,
  );
}

// -----------------------------------------------------------------------------
// Utils
// -----------------------------------------------------------------------------

/// Handles file/folder de-/selection
Future<void> _handleNodeSelection(
  BuildContext context, {
  bool reloadNode = false,
  required String fullPath,
  required bool isSelected,
  List<String>? filePaths,
}) async {
  // Deselect the file, or all files in the folder (recursively)
  if (!isSelected) {
    final blocks = context.promptBlocks;
    final blocksToRemove =
        blocks
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
}

/// Loads all file paths that are children of the given file path
List<String> _loadFilePaths(String givenPath) {
  final isDirectory = FileSystemEntity.isDirectorySync(givenPath);
  if (!isDirectory) return [givenPath];
  final dir = Directory(givenPath);
  return dir.listSync(recursive: true).map((e) => e.path).toList();
}

/// Handles raw data formats (SimpleFileFormat from super_drag_n_drop)
// Future<void> _handleDataFormat(BuildContext context, SimpleFileFormat format) async {
//   final reader = context.read<DataReader>();
//   final data = await reader.read(format);
//   if (data == null) return;
//   final blocks = await context.db.createBlocksFromData(data, context.prompt!.id);
// }
