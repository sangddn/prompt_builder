import 'dart:io';

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
import '../../pages/local_file_viewer/local_file_viewer.dart';
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
    this.countSelection,
    this.onNodeSelected,
    this.skipHiddenFoldersAndFiles = true,
    this.ignorePatterns = const IList.empty(),
    this.sortPreferences = const FileTreeSortPreferences(),
    this.curve = Effects.engagingCurve,
    this.builder,
    super.key,
  });

  /// Whether to hide files and folders that start with a dot
  final bool skipHiddenFoldersAndFiles;

  /// The root directory path to display
  final String? dirPath;

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

  /// Callback to handle node selection.
  final void Function(BuildContext, IndexedFileTree, bool)? onNodeSelected;

  /// Custom builder for the node.
  final Widget Function(BuildContext, IndexedFileTree)? builder;

  @override
  State<FileTree> createState() => _FileTreeState();
}

class _FileTreeState extends State<FileTree> {
  FileTreeController? _controller;
  late Future<IndexedFileTree?> _treeFuture = _getFileTree();

  /// Builds the file tree in a separate isolate to avoid blocking the UI
  Future<IndexedFileTree?> _getFileTree() => compute(
        _buildFileTree,
        _BuildFileTreeParams(
          dirPath: widget.dirPath,
          skipHidden: widget.skipHiddenFoldersAndFiles,
          ignorePatterns: widget.ignorePatterns,
          sortPreferences: widget.sortPreferences,
        ),
      );

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

        return Provider<FileTreeController?>.value(
          value: _controller,
          child: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(child: loadingIndicator),
              if (tree != null)
                SliverTreeView.indexed(
                  tree: tree,
                  showRootNode: false,
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
                          onItemSelected: (isSelected) =>
                              widget.onNodeSelected?.call(
                            context,
                            node,
                            isSelected,
                          ),
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
