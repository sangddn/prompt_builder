part of 'markdown.dart';

abstract class ThemedSyntaxHighlighter extends fm.SyntaxHighlighter {
  Map<String, TextStyle> get theme;
  String get fontFamily;
}

class DefaultSyntaxHighlighter extends ThemedSyntaxHighlighter {
  DefaultSyntaxHighlighter({
    this.tabSize = 8,
    this.language,
    this.fontFamily = 'GeistMono',
    required this.theme,
  });

  DefaultSyntaxHighlighter.fromContext(
    BuildContext context, {
    int tabSize = 8,
    String? language,
    String fontFamily = 'GeistMono',
  }) : this(
          tabSize: tabSize,
          language: language,
          fontFamily: fontFamily,
          theme: context.theme.resolveBrightness(
            tomorrowTheme,
            tomorrowNightTheme,
          ),
        );

  final int tabSize;
  final String? language;

  @override
  final String fontFamily;

  @override
  final Map<String, TextStyle> theme;

  @override
  TextSpan format(String source) {
    final parsedSource = source.replaceAll('\t', ' ' * tabSize);
    final nodes = highlight
        .parse(
          parsedSource,
          language: language,
          autoDetection: language == null,
        )
        .nodes!;
    final spans = parseSpans(nodes);
    return TextSpan(children: spans, style: TextStyle(fontFamily: fontFamily));
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
        currentSpans
            .add(TextSpan(children: tmp, style: theme[node.className!]));
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
