part of 'file_tree.dart';

/// Peek a local file in a sheet to the right.
Future<void> peekFile(BuildContext context, String filePath) => showShadSheet(
      side: ShadSheetSide.right,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => BCVLocal(filePath: filePath),
    );

typedef OnItemSelectedCallback = Future<void> Function(bool);

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
  ;

  String get label => switch (this) {
        name => 'Name',
        dateCreated => 'Creation Date',
        dateModified => 'Modified Date',
        size => 'Size',
      };
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

  FileTreeSortPreferences copyWith({
    FileTreeSortOption? sortOption,
    bool? foldersFirst,
    bool? ascending,
  }) =>
      FileTreeSortPreferences(
        sortOption: sortOption ?? this.sortOption,
        foldersFirst: foldersFirst ?? this.foldersFirst,
        ascending: ascending ?? this.ascending,
      );
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

  @override
  bool operator ==(Object other) =>
      other is FileTreeItem &&
      other.name == name &&
      other.path == path &&
      other.isDirectory == isDirectory &&
      other.extension == extension &&
      other.dateCreated == dateCreated &&
      other.dateModified == dateModified &&
      other.size == size;

  @override
  int get hashCode => Object.hash(
        name,
        path,
        isDirectory,
        extension,
        dateCreated,
        dateModified,
        size,
      );

  FileTreeItem copyWith({
    String? name,
    String? path,
    bool? isDirectory,
    String? extension,
    DateTime? dateCreated,
    DateTime? dateModified,
    int? size,
    int? numFilesRecursive,
    int? numDirectFiles,
  }) =>
      FileTreeItem(
        name: name ?? this.name,
        path: path ?? this.path,
        isDirectory: isDirectory ?? this.isDirectory,
        extension: extension ?? this.extension,
        dateCreated: dateCreated ?? this.dateCreated,
        dateModified: dateModified ?? this.dateModified,
        size: size ?? this.size,
        numFilesRecursive: numFilesRecursive ?? this.numFilesRecursive,
        numDirectFiles: numDirectFiles ?? this.numDirectFiles,
      );
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
(IndexedFileTree, List<String>, List<String>)? _buildFileTree(
  _BuildFileTreeParams params,
) {
  final dirPath = params.dirPath;
  final filePaths = <String>[];
  final folderPaths = <String>[];

  if (dirPath == null) return null;

  final root = IndexedTreeNode.root(
    data: FileTreeItem(
      name: path.basename(dirPath),
      path: dirPath,
      isDirectory: true,
      extension: null,
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

    if (isDirectory) {
      folderPaths.add(absolutePath);
    } else {
      filePaths.add(absolutePath);
    }

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
            final subDirFiles = (node.children.lastOrNull as IndexedFileTree?)
                    ?.data
                    ?.numFilesRecursive ??
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
      } catch (e, s) {
        debugPrint('Error accessing directory $basename: $e. Stack: $s');
        rethrow;
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

  return (root, filePaths, folderPaths);
}

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

// -----------------------------------------------------------------------------
// File system event handlers
// -----------------------------------------------------------------------------

void _handleCreateEvent(
  IndexedFileTree root,
  FileSystemCreateEvent event,
  FileTreeSortPreferences prefs,
) {
  // Skip if the node already exists
  if (_findNodeByPath(root, event.path) != null) return;

  // Find parent directory node
  final parentPath = path.dirname(event.path);
  final parentNode = _findNodeByPath(root, parentPath);
  if (parentNode == null) return;

  // Create new node
  final entity = event.isDirectory ? Directory(event.path) : File(event.path);

  try {
    final stat = entity.statSync();
    final basename = path.basename(event.path);
    final isDirectory = event.isDirectory;
    final extension = isDirectory ? null : path.extension(event.path);

    final newNode = IndexedTreeNode(
      parent: parentNode,
      data: FileTreeItem(
        name: basename,
        path: event.path,
        isDirectory: isDirectory,
        extension: extension,
        dateCreated: stat.changed,
        dateModified: stat.modified,
        size: stat.size,
        numFilesRecursive: isDirectory ? 0 : null,
        numDirectFiles: isDirectory ? 0 : null,
      ),
    );

    // Insert node maintaining sort order
    _insertNodeSorted(parentNode, newNode, prefs);

    // Update parent directory counts if this is a file.
    // If it's a directory that contains other files, it will be updated when
    // the creation events for the files are processed.
    if (!event.isDirectory) {
      _deincrementFileCountForDir(
        parentNode,
        isDirect: true,
        shouldIncrement: true,
      );
    }
  } catch (e) {
    debugPrint('Error handling create event: $e');
  }
}

void _handleModifyEvent(IndexedFileTree root, FileSystemModifyEvent event) {
  final node = _findNodeByPath(root, event.path);
  if (node == null) return;
  final item = node.data!;

  try {
    final stat = event.isDirectory
        ? Directory(event.path).statSync()
        : File(event.path).statSync();

    // Update node metadata while preserving children
    node.data = FileTreeItem(
      name: item.name,
      path: item.path,
      isDirectory: item.isDirectory,
      extension: item.extension,
      dateCreated: stat.changed,
      dateModified: stat.modified,
      size: stat.size,
      numFilesRecursive: item.numFilesRecursive,
      numDirectFiles: item.numDirectFiles,
    );
  } catch (e) {
    debugPrint('Error handling modify event: $e');
  }
}

void _handleDeleteEvent(IndexedFileTree root, FileSystemDeleteEvent event) {
  final node = _findNodeByPath(root, event.path);
  if (node == null) return;

  final parent = node.parent;
  if (parent == null) return;

  // Remove node
  parent.remove(node);

  // Update parent directory counts
  _deincrementFileCountForDir(
    parent as IndexedFileTree,
    isDirect: true,
    shouldIncrement: false,
  );
}

void _handleMoveEvent(
  IndexedFileTree root,
  FileSystemMoveEvent event,
  FileTreeSortPreferences prefs,
) {
  final sourceNode = _findNodeByPath(root, event.path);
  if (sourceNode == null) return;

  // If we have destination info, move the node
  if (event.destination != null) {
    final destParentPath = path.dirname(event.destination!);
    final destParent = _findNodeByPath(root, destParentPath);

    if (destParent != null) {
      // Remove from old parent
      sourceNode.parent?.children.remove(sourceNode);

      // Update node path
      sourceNode.data = sourceNode.data!.copyWith(
        path: event.destination,
        name: path.basename(event.destination!),
      );

      // Add to new parent
      sourceNode.parent = destParent;
      _insertNodeSorted(destParent, sourceNode, prefs);

      // Update counts for both old and new parent
      if (sourceNode.parent != null) {
        _deincrementFileCountForDir(
          sourceNode.parent! as IndexedFileTree,
          isDirect: true,
          shouldIncrement: false,
        );
      }
      if (sourceNode.parent != destParent) {
        _deincrementFileCountForDir(
          destParent,
          isDirect: true,
          shouldIncrement: true,
        );
      }
    }
  }
}

// Helper to find a node by its path
IndexedFileTree? _findNodeByPath(IndexedFileTree root, String searchPath) {
  if (root.data?.path == searchPath) return root;

  for (final child in root.children) {
    final result = _findNodeByPath(child as IndexedFileTree, searchPath);
    if (result != null) return result;
  }

  return null;
}

// Helper to insert a node while maintaining sort order
void _insertNodeSorted(
  IndexedFileTree parent,
  IndexedFileTree newNode,
  FileTreeSortPreferences prefs,
) {
  final index = parent.children.indexWhere((child) {
    final childData = (child as IndexedFileTree).data!;
    final newData = newNode.data!;

    if (prefs.foldersFirst && childData.isDirectory != newData.isDirectory) {
      return !childData.isDirectory;
    }

    final comparison = _compareEntities(
      _getEntity(child),
      _getEntity(newNode),
      prefs,
    );

    return comparison > 0;
  });

  if (index == -1) {
    parent.add(newNode);
  } else {
    parent.insert(index > 0 ? index - 1 : 0, newNode);
  }
}

// Helper to update directory counts
void _deincrementFileCountForDir(
  IndexedFileTree directory, {
  bool isDirect = false,
  required bool shouldIncrement,
}) {
  final item = directory.data!;
  if (!item.isDirectory) return;

  directory.data = item.copyWith(
    numFilesRecursive:
        (item.numFilesRecursive ?? 0) + (shouldIncrement ? 1 : -1),
    numDirectFiles: (item.numDirectFiles ?? 0) +
        (shouldIncrement ? (isDirect ? 1 : 0) : -(isDirect ? 1 : 0)),
  );

  if (directory.parent case final parent?) {
    _deincrementFileCountForDir(
      parent as IndexedFileTree,
      shouldIncrement: shouldIncrement,
    );
  }
}

FileSystemEntity _getEntity(IndexedFileTree node) =>
    node.data!.isDirectory ? Directory(node.data!.path) : File(node.data!.path);

// -----------------------------------------------------------------------------
// Notifications
// -----------------------------------------------------------------------------

sealed class FileTreeNotification extends Notification {}

class NodeSelectionNotification extends FileTreeNotification {
  NodeSelectionNotification(this.path, this.isSelected);

  final String path;
  final bool isSelected;
}

class TreeReadyNotification extends FileTreeNotification {
  TreeReadyNotification(this.tree, this.filePaths, this.folderPaths);

  final IndexedFileTree tree;
  final List<String> filePaths;
  final List<String> folderPaths;
}

class EntityEventNotification extends FileTreeNotification {
  EntityEventNotification(this.event);

  final FileSystemEvent event;
}
