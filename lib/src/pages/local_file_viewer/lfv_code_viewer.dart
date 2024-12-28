part of 'local_file_viewer.dart';

class _CodeViewer extends StatelessWidget {
  const _CodeViewer({
    required this.fileContent,
    required this.fileType,
  });

  final String fileContent;
  final String fileType;

  @override
  Widget build(BuildContext context) {
    final language = fileType.substring(1);
    return SingleChildScrollView(
      child: HighlightView(
        fileContent,
        syntaxHighlighter: DefaultSyntaxHighlighter.fromContext(
          context,
          language: language,
        ),
      ),
    );
  }
}

/// An improved version of `flutter_highlight`'s `HighlightView` widget that
/// allows for selecting text and caching the parsed nodes and spans.
class HighlightView extends StatefulWidget {
  const HighlightView(
    this.input, {
    required this.syntaxHighlighter,
    super.key,
  });

  final String input;
  final ThemedSyntaxHighlighter syntaxHighlighter;

  @override
  State<HighlightView> createState() => _HighlightViewState();
}

class _HighlightViewState extends State<HighlightView> {
  ThemedSyntaxHighlighter get _highlighter => widget.syntaxHighlighter;
  late var _span = _highlighter.format(widget.input);

  @override
  void didUpdateWidget(HighlightView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.input != widget.input) {
      _span = _highlighter.format(widget.input);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: Superellipse.border8,
        color: _highlighter.theme['root']?.backgroundColor,
      ),
      padding: k12H8VPadding,
      child: SelectableText.rich(
        _span,
        style: context.textTheme.p.copyWith(
          fontFamily: 'GeistMono',
          color: _highlighter.theme['root']?.color,
        ),
      ),
    );
  }
}
