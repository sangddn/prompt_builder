part of 'prompt_block_card.dart';

class _ImageBlock extends StatelessWidget {
  const _ImageBlock();

  @override
  Widget build(BuildContext context) {
    final description = context.selectBlock((b) => b.caption);
    final (path, url) = context.selectBlock((b) => (b.filePath, b.url));
    if (path == null && url == null) return const SizedBox.shrink();
    final isExpanded = context.isExpanded();
    final height = isExpanded ? 256.0 : 48.0;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Row(
        children: [
          if (path != null)
            ClipPath(
              clipper: const ShapeBorderClipper(shape: Superellipse.border8),
              child: Image.file(File(path), height: height, width: height),
            )
          else
            Image.network(url!, height: height, width: height),
          const Gap(8.0),
          Expanded(
            child: Container(
              padding: k12APadding,
              height: height,
              decoration: ShapeDecoration(
                shape: Superellipse.border12,
                color: context.colorScheme.accent,
              ),
              child: SingleChildScrollView(
                child: Text(
                  description ?? 'No description available.',
                  style: context.textTheme.muted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
