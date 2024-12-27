import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/tomorrow-night.dart';
import 'package:flutter_highlight/themes/tomorrow.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:highlight/highlight.dart';
import 'package:path/path.dart' as path;
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../services/services.dart';

part 'lfv_code_viewer.dart';
part 'lfv_image_viewer.dart';
part 'lfv_text_viewer.dart';

class LocalFileViewer extends StatelessWidget {
  const LocalFileViewer({
    this.actions,
    required this.filePath,
    super.key,
  });

  final List<Widget>? actions;
  final String filePath;

  static bool isSupportedFile(String filePath) =>
      isImageFile(filePath) ||
      isCodeFile(filePath) ||
      canBeRepresentedAsText(filePath);

  @override
  Widget build(BuildContext context) {
    return ShadSheet(
      title: Row(
        children: [
          Text(
            path.basename(filePath),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(6.0),
          Expanded(
            child: Text(
              filePath,
              style: context.textTheme.muted,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      description: actions != null
          ? Row(
              spacing: 8.0,
              children: actions!,
            )
          : null,
      gap: 16.0,
      constraints: const BoxConstraints(minWidth: 500, maxWidth: 750),
      enterDuration: const Duration(milliseconds: 100),
      exitDuration: const Duration(milliseconds: 100),
      child: _FileViewerContent(filePath),
    );
  }
}

class _FileViewerContent extends StatefulWidget {
  const _FileViewerContent(this.path);

  final String path;

  @override
  State<_FileViewerContent> createState() => __FileViewerContentState();
}

class __FileViewerContentState extends State<_FileViewerContent> {
  late var _path = widget.path;
  late var _fileType = path.extension(_path).toLowerCase();
  Future<String?>? _fileContentFuture;

  @override
  void didUpdateWidget(_FileViewerContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _path = widget.path;
      _fileType = path.extension(_path).toLowerCase();
      _fileContentFuture = null;
    }
  }

  Future<String?>? _getFileContent() {
    if (_fileContentFuture != null) return _fileContentFuture;
    final toaster = context.toaster;
    try {
      final file = File(_path);
      return _fileContentFuture = file.readAsString();
    } catch (e) {
      debugPrint('Error loading file: $e');
      toaster.show(
        ShadToast.destructive(
          title: const Text('Error loading file.'),
          description: Text('$_path\n$e.'),
        ),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!LocalFileViewer.isSupportedFile(_path)) {
      return Center(
        child: Column(
          children: [
            const Text('Unsupported file type.'),
            const Gap(8.0),
            ShadButton.outline(
              onPressed: () => revealInFinder(_path),
              child: const Text('Show in Finder'),
            ),
          ],
        ),
      );
    }
    if (isImageFile(_fileType)) {
      return _ImageViewer(filePath: _path);
    }
    return FutureBuilder(
      future: _getFileContent(),
      builder: (context, snapshot) {
        final content = snapshot.data;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        if (isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (content == null) {
          return const Center(child: Text('Failed to load file.'));
        }
        return isCodeFile(_fileType)
            ? _CodeViewer(
                fileContent: content,
                fileType: _fileType,
              )
            : _TextViewer(content: content);
      },
    );
  }
}
