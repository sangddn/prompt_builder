part of 'prompt_block_card.dart';

class _LocalFileBlock extends AnimatedStatelessWidget {
  const _LocalFileBlock();

  @override
  Widget buildChild(BuildContext context) {
    final style = context.textTheme.p;
    final (isCode, content) = context.selectBlock(
      (b) => (
        b.filePath?.let(isCodeFile) ?? false,
        b.preferSummary ? b.summary : b.textContent
      ),
    );
    final isExpanded = context.isExpanded();
    return Container(
      key: ValueKey(isExpanded),
      padding: k12APadding,
      decoration: ShapeDecoration(
        shape: Superellipse.border12,
        color: context.colorScheme.accent,
      ),
      width: double.infinity,
      child: Text(
        content ?? 'No content available.',
        style: style.copyWith(fontFamily: isCode ? 'GeistMono' : null),
        maxLines: isExpanded ? 200 : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
