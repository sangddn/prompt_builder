part of 'file_tree.dart';

/// Peek a local file in a sheet to the right.
Future<void> peekFile(BuildContext context, String filePath) => showShadSheet(
      side: ShadSheetSide.right,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => LocalFileViewer(filePath: filePath),
    );

/// Defines sorting options for the file tree
enum FileTreeSortOption {
  /// Sort by file/folder name
  name,

  /// Sort by creation date
  dateCreated,

  /// Sort by last modified date
  dateModified,

  /// Sort by file size
  size,
}

/// Preferences for sorting the file tree
@immutable
class FileTreeSortPreferences {
  const FileTreeSortPreferences({
    this.sortOption = FileTreeSortOption.name,
    this.foldersFirst = true,
    this.ascending = true,
  });

  /// The selected sorting option
  final FileTreeSortOption sortOption;

  /// Whether folders should be displayed before files
  final bool foldersFirst;

  /// Whether to sort in ascending order
  final bool ascending;

  @override
  bool operator ==(Object other) =>
      other is FileTreeSortPreferences &&
      other.sortOption == sortOption &&
      other.foldersFirst == foldersFirst &&
      other.ascending == ascending;

  @override
  int get hashCode => Object.hash(sortOption, foldersFirst, ascending);
}

/// Represents an item in the file tree
@immutable
class FileTreeItem {
  const FileTreeItem({
    required this.name,
    required this.path,
    required this.extension,
    required this.isDirectory,
    this.dateCreated,
    this.dateModified,
    this.size,
    this.numFilesRecursive,
    this.numDirectFiles,
  });

  /// The name of the file or folder
  final String name;

  /// The absolute path to the file or folder
  final String path;

  /// Whether this item is a directory
  final bool isDirectory;

  /// File extension (null for directories)
  final String? extension;

  /// Creation date of the file/folder
  final DateTime? dateCreated;

  /// Last modified date of the file/folder
  final DateTime? dateModified;

  /// Size in bytes (null for directories)
  final int? size;

  /// Total number of files in the folder and all subfolders (null for files)
  final int? numFilesRecursive;

  /// Number of files in the folder, not including subfolders (null for files)
  final int? numDirectFiles;
}

/// Type alias for a tree node containing file information
typedef IndexedFileTree = IndexedTreeNode<FileTreeItem>;

/// Type alias for a controller for the file tree
typedef FileTreeController = TreeViewController<FileTreeItem, IndexedFileTree>;

/// Parameters for building the file tree, passed to the isolate
@immutable
class _BuildFileTreeParams {
  const _BuildFileTreeParams({
    required this.dirPath,
    required this.skipHidden,
    required this.ignorePatterns,
    required this.sortPreferences,
  });

  final String? dirPath;
  final bool skipHidden;
  final IList<String> ignorePatterns;
  final FileTreeSortPreferences sortPreferences;
}

/// Builds a hierarchical tree structure from the file system
///
/// This method runs in a separate isolate to prevent UI blocking during
/// file system operations.
IndexedFileTree? _buildFileTree(_BuildFileTreeParams params) {
  final dirPath = params.dirPath;
  if (dirPath == null) return null;

  final root = IndexedTreeNode.root(
    data: FileTreeItem(
      name: path.basename(dirPath),
      path: dirPath,
      isDirectory: true,
      extension: '',
    ),
  );

  /// Checks if a path should be ignored based on patterns and hidden file rules
  bool shouldIgnorePath(String filePath, bool isDirectory) {
    final basename = path.basename(filePath);
    if (basename.startsWith('.') && params.skipHidden) {
      return true;
    }

    final relativePath = path.relative(filePath, from: dirPath);

    for (final pattern in params.ignorePatterns) {
      final trimmedPattern = pattern.trim();
      if (trimmedPattern.isEmpty || trimmedPattern.startsWith('#')) continue;

      /// Convert glob patterns to regex
      final regexPattern = trimmedPattern
          .replaceAll('.', r'\.')
          .replaceAll('*', '.*')
          .replaceAll('?', '.');

      if (RegExp(regexPattern).hasMatch(relativePath)) return true;
    }

    return false;
  }

  /// Recursively adds file system entities to the tree
  void addFileSystemEntity(IndexedFileTree parent, FileSystemEntity entity) {
    final absolutePath = entity.path;
    final basename = path.basename(absolutePath);
    final isDirectory = entity is Directory;

    if (shouldIgnorePath(absolutePath, isDirectory)) return;

    final stat = entity.statSync();
    final extension = isDirectory ? null : path.extension(absolutePath);

    // Create node without children first
    final node = IndexedTreeNode(
      parent: parent,
      data: FileTreeItem(
        name: basename,
        path: absolutePath,
        isDirectory: isDirectory,
        extension: extension,
        dateCreated: stat.changed,
        dateModified: stat.modified,
        size: stat.size,
        // Initialize counts as 0 for directories
        numFilesRecursive: isDirectory ? 0 : null,
        numDirectFiles: isDirectory ? 0 : null,
      ),
    );

    int totalFiles = 0;
    int directFiles = 0;

    if (isDirectory) {
      try {
        final subEntities = Directory(absolutePath).listSync()
          ..sort((a, b) => _compareEntities(a, b, params.sortPreferences));
        for (final subEntity in subEntities) {
          addFileSystemEntity(node, subEntity);

          // Count files in subdirectories
          if (subEntity is! Directory) {
            directFiles++;
            totalFiles++;
          } else {
            // Add files from subdirectories to total
            final subDirFiles = (node.children.last as IndexedFileTree)
                    .data!
                    .numFilesRecursive ??
                0;
            totalFiles += subDirFiles;
          }
        }

        // Update the node's data with file counts
        node.data = FileTreeItem(
          name: basename,
          path: absolutePath,
          isDirectory: isDirectory,
          extension: extension,
          dateCreated: stat.changed,
          dateModified: stat.modified,
          size: stat.size,
          numFilesRecursive: totalFiles,
          numDirectFiles: directFiles,
        );
      } catch (e) {
        debugPrint('Error accessing directory $basename: $e');
      }
    }

    parent.add(node);
  }

  final dir = Directory(dirPath);
  final entities = dir.listSync()
    ..sort((a, b) => _compareEntities(a, b, params.sortPreferences));
  for (final entity in entities) {
    addFileSystemEntity(root, entity);
  }

  return root;
}

/// Compares two file system entities based on the provided sort preferences
int _compareEntities(
  FileSystemEntity a,
  FileSystemEntity b,
  FileTreeSortPreferences prefs,
) {
  final aIsDir = a is Directory;
  final bIsDir = b is Directory;

  if (prefs.foldersFirst && aIsDir != bIsDir) {
    return aIsDir ? -1 : 1;
  }

  final aStat = a.statSync();
  final bStat = b.statSync();
  final multiplier = prefs.ascending ? 1 : -1;

  switch (prefs.sortOption) {
    case FileTreeSortOption.name:
      return multiplier *
          path.basename(a.path).compareTo(path.basename(b.path));
    case FileTreeSortOption.dateCreated:
      return multiplier * aStat.changed.compareTo(bStat.changed);
    case FileTreeSortOption.dateModified:
      return multiplier * aStat.modified.compareTo(bStat.modified);
    case FileTreeSortOption.size:
      return multiplier * aStat.size.compareTo(bStat.size);
  }
}
