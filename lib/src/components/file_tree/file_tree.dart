import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide TreeViewController;

import '../../core/core.dart';
import '../../pages/block_content_viewer/block_content_viewer.dart';
import '../../services/services.dart';
import '../components.dart';

part 'file_tree_utils.dart';
part 'selectable_file_tree_item.dart';
part 'item_previewer.dart';

/// A widget that displays a hierarchical file tree with sorting and filtering
/// options.
class FileTree extends StatefulWidget {
  const FileTree({
    required this.dirPath,
    this.showRootNode = false,
    this.countSelection,
    this.skipHiddenFoldersAndFiles = true,
    this.ignorePatterns = const IList.empty(),
    this.sortPreferences = const FileTreeSortPreferences(),
    this.curve = Effects.snappyOutCurve,
    this.builder,
    super.key,
  });

  /// Whether to hide files and folders that start with a dot
  final bool skipHiddenFoldersAndFiles;

  /// The root directory path to display
  final String? dirPath;

  /// Whether to show the root node
  final bool showRootNode;

  /// List of glob patterns to ignore
  final IList<String> ignorePatterns;

  /// Sorting preferences for the file tree
  final FileTreeSortPreferences sortPreferences;

  /// Animation curve
  final Curve curve;

  /// Callback to determine the number of selected items.
  /// - For a file, returns 1 if the file is selected, 0 otherwise.
  /// - For a folder, returns the number of selected files in the folder.
  final int Function(BuildContext, FileTreeItem)? countSelection;

  /// Custom builder for the node.
  final Widget Function(BuildContext, IndexedFileTree)? builder;

  @override
  State<FileTree> createState() => _FileTreeState();
}

class _FileTreeState extends State<FileTree> with _WatchDirectoryMixin {
  FileTreeController? _controller;
  @override
  IndexedFileTree? _root;
  // Tree - File paths - Folder paths
  late Future<(IndexedFileTree, List<String>, List<String>)?> _treeFuture =
      _getFileTree();

  /// Builds the file tree in a separate isolate to avoid blocking the UI
  Future<(IndexedFileTree, List<String>, List<String>)?> _getFileTree() async {
    final toaster = context.toaster;
    _root = null;
    try {
      final result = await compute(
        _buildFileTree,
        _BuildFileTreeParams(
          dirPath: widget.dirPath,
          skipHidden: widget.skipHiddenFoldersAndFiles,
          ignorePatterns: widget.ignorePatterns,
          sortPreferences: widget.sortPreferences,
        ),
      );
      if (result != null && mounted) {
        _root = result.$1;
        TreeReadyNotification(result.$1, result.$2, result.$3)
            .dispatch(context);
      }
      return result;
    } catch (e) {
      toaster.show(
        ShadToast.destructive(
          title: const Text('Error loading file tree'),
          description: Text(e.toString()),
        ),
      );
      return null;
    }
  }

  @override
  void didUpdateWidget(FileTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dirPath != widget.dirPath ||
        oldWidget.ignorePatterns != widget.ignorePatterns ||
        oldWidget.sortPreferences != widget.sortPreferences) {
      _treeFuture = _getFileTree();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _treeFuture,
      builder: (context, snapshot) {
        final tree = snapshot.data;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final loadingIndicator = StateAnimations.sizeFade(
          isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              : const SizedBox.shrink(),
          layoutBuilder: alignedLayoutBuilder(Alignment.topCenter),
        );

        return MultiProvider(
          providers: [
            Provider<FileTreeController?>.value(value: _controller),
            Provider<(IList<String>, IList<String>)>.value(
              value: (IList(tree?.$2), IList(tree?.$3)),
            ),
          ],
          child: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(child: loadingIndicator),
              if (tree != null)
                SliverTreeView.indexed(
                  tree: tree.$1,
                  showRootNode: widget.showRootNode,
                  animation: (animation) => CurvedAnimation(
                    parent: animation,
                    curve: widget.curve,
                    reverseCurve: widget.curve,
                  ),
                  builder: widget.builder ??
                      (context, IndexedTreeNode<FileTreeItem> node) {
                        return SelectableFileTreeItem(
                          selectionCount: widget.countSelection
                                  ?.call(context, node.data!) ??
                              0,
                          onItemSelected: (isSelected) async =>
                              NodeSelectionNotification(
                            node.data!.path,
                            isSelected,
                          ).dispatch(context),
                          node: node,
                        );
                      },
                  expansionIndicatorBuilder: (context, node) =>
                      ChevronIndicator.rightDown(
                    tree: node,
                    color: PColors.textGray.resolveFrom(context),
                    padding: const EdgeInsets.all(8),
                  ),
                  indentation: Indentation(
                    style: IndentStyle.roundJoint,
                    color: PColors.gray.resolveFrom(context),
                    offset: const Offset(6.0, 0.0),
                  ),
                  onTreeReady: (controller) =>
                      setState(() => _controller = controller),
                ),
              const SliverGap(8.0),
            ],
          ),
        );
      },
    );
  }
}

mixin _WatchDirectoryMixin on State<FileTree> {
  IndexedFileTree? get _root;
  StreamSubscription<FileSystemEvent>? _eventSubscription;

  void _onEvent(FileSystemEvent event) {
    final root = _root;
    if (root == null) return;
    EntityEventNotification(event).dispatch(context);
    switch (event) {
      case FileSystemCreateEvent():
        _handleCreateEvent(root, event, widget.sortPreferences);
      case FileSystemModifyEvent():
        _handleModifyEvent(root, event);
      case FileSystemDeleteEvent():
        _handleDeleteEvent(root, event);
      case FileSystemMoveEvent():
        _handleMoveEvent(root, event, widget.sortPreferences);
    }
  }

  void _watch() {
    _eventSubscription?.cancel();
    if (widget.dirPath == null) return;
    final dir = Directory(widget.dirPath!);
    _eventSubscription = dir.watch(recursive: true).listen(_onEvent);
  }

  @override
  void initState() {
    super.initState();
    _watch();
  }

  @override
  void didUpdateWidget(FileTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dirPath != widget.dirPath ||
        oldWidget.sortPreferences != widget.sortPreferences) {
      _watch();
    }
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }
}
