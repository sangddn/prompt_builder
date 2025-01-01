import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as path;
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../services/services.dart';

part 'bcv_text.dart';
part 'bcv_local.dart';
part 'bcv_web.dart';
part 'bcv_code_viewer.dart';
part 'bcv_image_viewer.dart';
part 'bcv_pdf_viewer.dart';

/// Peek a block in a sheet to the right.
/// A more general version of [peekFile].
Future<void> peekBlock(BuildContext context, PromptBlock block) =>
    showShadSheet(
      side: ShadSheetSide.right,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => BlockContentViewer(block: block),
    );

class BlockContentViewer extends StatefulWidget {
  const BlockContentViewer({
    required this.block,
    super.key,
  });

  final PromptBlock block;

  @override
  State<BlockContentViewer> createState() => _BlockContentViewerState();
}

class _BlockContentViewerState extends State<BlockContentViewer> {
  PromptBlock get block => widget.block;
  bool get _isWebView =>
      block.type == BlockType.webUrl || block.type == BlockType.youtube;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isWebView && block.url == null) {
        context.toaster.show(
          const ShadToast.destructive(
            title: Text('Error opening web page.'),
            description: Text('No URL found.'),
          ),
        );
        Navigator.of(context).maybePop();
      } else if (block.type == BlockType.text && block.textContent == null) {
        context.toaster.show(
          const ShadToast.destructive(
            title: Text('Error opening text.'),
            description: Text('No text found.'),
          ),
        );
        Navigator.of(context).maybePop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (block.type == BlockType.webUrl || block.type == BlockType.youtube) {
      final url = block.url;
      if (url == null) {
        return const SizedBox.shrink();
      }
      return BCVWebView(
        url: url,
        title: block.displayName,
        textContent: block.textContent,
        transcript: block.transcript,
        summary: block.summary,
      );
    }
    // This should covers .audio, .image, .video, .localFile
    if (widget.block.filePath case final filePath?) {
      return BCVLocal(
        title: block.displayName,
        caption: block.caption,
        summary: block.summary,
        transcript: block.transcript,
        filePath: filePath,
      );
    }
    final text = block.textContent;
    if (text != null) {
      return _BCVText(
        title: block.displayName,
        text: text,
      );
    }
    return const SizedBox.shrink();
  }
}
