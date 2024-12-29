part of 'prompt_block_card.dart';

class _UnsupportedBlock extends StatelessWidget {
  const _UnsupportedBlock();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.p;
    return Column(
      children: [
        Text(
          'Unsupported Block Type',
          style: style.copyWith(color: Colors.red),
        ),
      ],
    );
  }
}
