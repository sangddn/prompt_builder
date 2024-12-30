part of 'prompt_block_card.dart';

class _LocalFileBlock extends StatelessWidget {
  const _LocalFileBlock();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.p;
    final content =
        context.selectBlock((b) => b.preferSummary ? b.summary : b.textContent);
    final isExpanded = context.isExpanded();
    return Container(
      padding: k12APadding,
      decoration: ShapeDecoration(
        shape: Superellipse.border12,
        color: context.colorScheme.accent,
      ),
      width: double.infinity,
      child: Text(
        content ?? 'No content available.',
        style: style,
        maxLines: isExpanded ? null : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
