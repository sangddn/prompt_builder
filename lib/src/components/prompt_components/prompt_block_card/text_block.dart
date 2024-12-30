part of 'prompt_block_card.dart';

class _TextBlock extends StatelessWidget {
  const _TextBlock();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.p;
    final textContent = context.selectBlock((b) => b.textContent);
    final isExpanded = context.isExpanded();
    return Column(
      children: [
        TextFormField(
          initialValue: textContent,
          decoration: InputDecoration(
            hintText: 'You are a helpful assistant',
            hintStyle:
                style.copyWith(color: PColors.textGray.resolveFrom(context)),
            border: InputBorder.none,
          ),
          minLines: 2,
          maxLines: isExpanded ? null : 3,
          style: style,
          onChanged: (value) =>
              context.db.updateBlock(context.block.id, textContent: value),
        ),
      ],
    );
  }
}
