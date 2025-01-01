part of 'block_content_viewer.dart';

class _BCVText extends StatelessWidget {
  const _BCVText({
    this.title,
    required this.text,
  });

  final String? title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ShadSheet(
      title: title?.let((t) => Text(t)),
      child: Text(text),
    );
  }
}
