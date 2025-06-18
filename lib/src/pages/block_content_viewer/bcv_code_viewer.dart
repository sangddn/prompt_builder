part of 'block_content_viewer.dart';

class _BCVCodeViewer extends StatelessWidget {
  const _BCVCodeViewer({
    required this.fileContent,
    required this.fileExtension,
  });

  final String fileContent;
  final String fileExtension;

  @override
  Widget build(BuildContext context) {
    final language = getCodeLanguage(fileExtension);
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
class HighlightView extends StatelessWidget {
  const HighlightView(this.input, {required this.syntaxHighlighter, super.key});

  final String input;
  final ThemedSyntaxHighlighter syntaxHighlighter;

  @override
  Widget build(BuildContext context) {
    final span = syntaxHighlighter.format(input);
    return Container(
      decoration: ShapeDecoration(
        shape: Superellipse.border8,
        color: syntaxHighlighter.theme['root']?.backgroundColor,
      ),
      padding: k12H8VPadding,
      child: SelectableText.rich(span, style: context.textTheme.p),
    );
  }
}
