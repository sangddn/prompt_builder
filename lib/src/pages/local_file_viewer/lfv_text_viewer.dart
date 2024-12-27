part of 'local_file_viewer.dart';

class _TextViewer extends StatelessWidget {
  const _TextViewer({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MarkdownBody(
        data: content,
        selectable: true,
        syntaxHighlighter: DefaultSyntaxHighlighter(
          theme: context.theme.resolveBrightness(
            tomorrowTheme,
            tomorrowNightTheme,
          ),
        ),
      ),
    );
  }
}
