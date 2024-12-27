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
        syntaxHighlighter: DefaultSyntaxHighlighter(
          language: language,
          theme: context.theme.resolveBrightness(
            tomorrowTheme,
            tomorrowNightTheme,
          ),
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

abstract class ThemedSyntaxHighlighter extends SyntaxHighlighter {
  Map<String, TextStyle> get theme;
}

class DefaultSyntaxHighlighter extends ThemedSyntaxHighlighter {
  DefaultSyntaxHighlighter({
    this.tabSize = 8,
    this.language,
    required this.theme,
  });

  final int tabSize;
  final String? language;

  @override
  final Map<String, TextStyle> theme;

  @override
  TextSpan format(String source) {
    final parsedSource = source.replaceAll('\t', ' ' * tabSize);
    final nodes = highlight.parse(parsedSource, language: language).nodes!;
    final spans = parseSpans(nodes);
    return TextSpan(children: spans);
  }

  List<TextSpan> parseSpans(List<Node> nodes) {
    final List<TextSpan> spans = [];
    var currentSpans = spans;
    final List<List<TextSpan>> stack = [];

    void traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(
          node.className == null
              ? TextSpan(text: node.value)
              : TextSpan(
                  text: node.value,
                  style: theme[node.className!],
                ),
        );
      } else if (node.children != null) {
        final List<TextSpan> tmp = [];
        currentSpans.add(
          TextSpan(children: tmp, style: theme[node.className!]),
        );
        stack.add(currentSpans);
        currentSpans = tmp;

        for (final n in node.children!) {
          traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
      }
    }

    nodes.forEach(traverse);

    return spans;
  }
}
