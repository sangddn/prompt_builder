part of 'prompt_block_card.dart';

class _WebBlock extends StatelessWidget {
  const _WebBlock();

  @override
  Widget build(BuildContext context) {
    final content =
        context.selectBlock((b) => b.preferSummary ? b.summary : b.textContent);
    final style = context.textTheme.p;
    final isExpanded = context.isExpanded();
    return Container(
      padding: k12APadding,
      decoration: ShapeDecoration(
        shape: Superellipse.border12,
        color: context.colorScheme.accent,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content == null ? 'Content not available.' : 'Content',
            style: context.textTheme.muted,
          ),
          if (content != null)
            Text(
              content,
              style: style,
              maxLines: isExpanded ? 200 : 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
