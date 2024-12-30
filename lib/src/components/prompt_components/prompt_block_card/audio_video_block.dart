part of 'prompt_block_card.dart';

class _AudioVideoBlock extends StatelessWidget {
  const _AudioVideoBlock();

  @override
  Widget build(BuildContext context) {
    final transcript =
        context.selectBlock((b) => b.preferSummary ? b.summary : b.transcript);
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
            transcript == null ? 'No transcript available.' : 'Transcript',
            style: context.textTheme.muted,
          ),
          if (transcript != null)
            Text(
              transcript,
              style: style,
              maxLines: isExpanded ? null : 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
