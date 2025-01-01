part of 'block_content_viewer.dart';

class _BCVPdfViewer extends StatefulWidget {
  const _BCVPdfViewer(this.path);

  final String path;

  @override
  State<_BCVPdfViewer> createState() => __BCVPdfViewerState();
}

class __BCVPdfViewerState extends State<_BCVPdfViewer> {
  String get _path => widget.path;
  late final PdfViewerController _controller;
  bool _isSaving = false, _isSaved = false;

  Future<void> _saveDocumentAndDispose(
    BuildContext context,
    void Function(VoidCallback) setState,
  ) async {
    final toaster = context.toaster;
    try {
      setState(() => _isSaving = true);
      final bytes = await _controller.saveDocument();
      final file = File(_path);
      await file.writeAsBytes(bytes);
      setState(() {
        _isSaved = true;
        _isSaving = false;
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) setState(() => _isSaved = false);
      });
    } catch (e, s) {
      debugPrint('Error saving PDF: $e - $s');
      toaster.show(
        ShadToast.destructive(
          title: const Text('Error saving PDF.'),
          description: Text('$e'),
        ),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: height - 220.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(8.0),
          Expanded(
            child: SfPdfViewer.file(
              File(_path),
              controller: _controller,
            ),
          ),
          const Gap(8.0),
          StatefulBuilder(
            builder: (context, setState) {
              return ShadButton.outline(
                onPressed: () => _saveDocumentAndDispose(context, setState),
                child: TranslationSwitcher.top(
                  duration: Effects.shortDuration,
                  child: _isSaving
                      ? const GrayShimmer(child: Text('Saving…'))
                      : _isSaved
                          ? const Text('Saved!', key: ValueKey(1))
                          : const Text('Save', key: ValueKey(2)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
