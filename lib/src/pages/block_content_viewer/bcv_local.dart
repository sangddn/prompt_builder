part of 'block_content_viewer.dart';

class BCVLocal extends StatelessWidget {
  const BCVLocal({
    this.actions,
    this.summary,
    this.transcript,
    this.caption,
    this.title,
    this.textContent,
    required this.filePath,
    super.key,
  });

  final List<Widget>? actions;
  final String? title, summary, transcript, caption, textContent;
  final String filePath;

  static bool isSupportedFile(String filePath) =>
      isImageFile(filePath) ||
      isPdfFile(filePath) ||
      isCodeFile(filePath) ||
      canBeRepresentedAsText(filePath);

  @override
  Widget build(BuildContext context) {
    return ShadSheet(
      title: title?.let((t) => Text(t)),
      actions: actions ?? const [],
      gap: 16.0,
      constraints: const BoxConstraints(minWidth: 500, maxWidth: 750),
      enterDuration: Effects.veryShortDuration,
      exitDuration: Effects.veryShortDuration,
      child: ShadTabs(
        value: isSupportedFile(filePath)
            ? 'content'
            : textContent != null
                ? 'textContent'
                : transcript != null
                    ? 'transcript'
                    : summary != null
                        ? 'summary'
                        : caption != null
                            ? 'caption'
                            : 'content',
        // expandContent: true,
        tabs: [
          ShadTab(
            value: 'content',
            content: ShadCard(
              columnMainAxisSize: MainAxisSize.min,
              title: Text(
                path.basename(filePath),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              description: Text(
                filePath,
                style: context.textTheme.muted,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              child: _FileViewerContent(filePath),
            ),
            child: const Text('Content'),
          ),
          if (transcript != null)
            ShadTab(
              value: 'transcript',
              content: ShadCard(
                title: const Text('Transcript'),
                description: const Text('Generated transcript for file.'),
                child: Text(transcript!),
              ),
              child: const Text('Transcript'),
            ),
          if (summary != null)
            ShadTab(
              value: 'summary',
              content: ShadCard(
                title: const Text('Summary'),
                description: const Text('Generated summary for file.'),
                child: Text(summary!),
              ),
              child: const Text('Summary'),
            ),
          if (caption != null)
            ShadTab(
              value: 'caption',
              content: ShadCard(
                title: const Text('Description'),
                description: const Text('Generated description for image.'),
                child: Text(caption!),
              ),
              child: const Text('Description'),
            ),
          if (textContent != null)
            ShadTab(
              value: 'textContent',
              content: ShadCard(
                title: const Text('Extracted Content'),
                child: Text(textContent!),
              ),
              child: const Text('Extracted Content'),
            ),
        ],
      ),
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
  Future<String?>? _fileContentFuture;

  @override
  void didUpdateWidget(_FileViewerContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _path = widget.path;
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
    if (!BCVLocal.isSupportedFile(_path)) {
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
    if (isImageFile(_path)) {
      return _BCVImageViewer(provider: FileImage(File(_path)));
    }
    if (isPdfFile(_path)) {
      return _BCVPdfViewer(_path);
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
        final extension =
            path.extension(_path).replaceAll('.', '').toLowerCase();
        return isMarkdownFile(_path) || !isCodeFile(extension)
            ? Markdown(data: content)
            : _BCVCodeViewer(
                fileContent: content,
                fileExtension: extension,
              );
      },
    );
  }
}
