part of 'prompt_block_card.dart';

class _UnsupportedBlock extends StatelessWidget {
  const _UnsupportedBlock();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.muted;
    return Text(
      'Unsupported type. This does not work with "Copy Prompt".',
      style: style,
    );
  }
}
