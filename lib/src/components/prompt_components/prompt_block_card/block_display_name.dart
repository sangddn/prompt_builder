part of 'prompt_block_card.dart';

enum _BlockDisplayNameState {
  idle,
  editing;

  bool get isEditing => this == _BlockDisplayNameState.editing;
}

class _BlockDisplayName extends StatelessWidget {
  const _BlockDisplayName();

  @override
  Widget build(BuildContext context) {
    final prompt = context.watch<Prompt?>();
    final hint = context.selectBlock((b) => b.getDefaultDisplayName(prompt));
    return StateProvider<_BlockDisplayNameState>(
      createInitialValue: (_) => _BlockDisplayNameState.idle,
      child: ValueProvider<TextEditingController>(
        create:
            (context) => TextEditingController(text: context.block.displayName),
        onNotified: (context, controller) {
          if (controller?.text != context.block.displayName) {
            context.db.updateBlock(
              context.block.id,
              displayName: controller?.text,
            );
          }
        },
        builder:
            (context, _) => TextField(
              controller: context.read(),
              readOnly: !context.watch<_BlockDisplayNameState>().isEditing,
              mouseCursor:
                  context.watch<_BlockDisplayNameState>().isEditing
                      ? SystemMouseCursors.text
                      : SystemMouseCursors.basic,
              style: context.textTheme.muted,
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: context.textTheme.muted.copyWith(
                  color: PColors.textGray.resolveFrom(context),
                ),
              ),
              onTap:
                  () =>
                      context
                          .read<ValueNotifier<_BlockDisplayNameState>>()
                          .value = _BlockDisplayNameState.editing,
              onTapOutside:
                  (_) =>
                      context
                          .read<ValueNotifier<_BlockDisplayNameState>>()
                          .value = _BlockDisplayNameState.idle,
            ),
      ),
    );
  }
}
