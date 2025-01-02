part of '../library_page.dart';

class _LPPromptList extends StatelessWidget {
  const _LPPromptList();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<_LibraryController>();
    return InfinityAndBeyond(
      controller: controller,
      padding: k16HPadding,
      itemPadding: k16H4VPadding,
      itemBuilder: (context, index, prompt) => PromptTile(
        db: context.db,
        onTap: () => context.router.push(PromptRoute(id: prompt.id)),
        onDeleted: () => controller._refresh(),
        prompt: prompt,
      )
          .animate()
          .fadeIn(
            delay: 50.ms * (index % _kPageSize),
            duration: 200.milliseconds,
          )
          .slideY(
            begin: 0.1,
            end: 0,
            delay: 50.ms * (index % _kPageSize),
            duration: 200.milliseconds,
          ),
    );
  }
}
