part of '../library_page.dart';

class _LPPromptList extends StatelessWidget {
  const _LPPromptList();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<_LibraryController>();
    final keys = <int, GlobalKey>{};
    return InfinityAndBeyond.grid(
      controller: controller,
      itemPadding: k16H4VPadding,
      childAspectRatio: 3.5 / 4,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 0.0,
      itemBuilder: (context, index, prompt) => PromptTile(
        key: keys.putIfAbsent(prompt.id, () => GlobalKey()),
        db: context.db,
        onTap: () => context.router.push(PromptRoute(id: prompt.id)),
        onDeleted: () {
          final c = controller.pagingController;
          c.itemList = List.of(c.itemList ?? [])
            ..removeWhere((p) => p.id == prompt.id);
        },
        onDuplicated: (newPromptId) async {
          final c = controller.pagingController;
          final newPrompt = await context.db.getPrompt(newPromptId);
          c.itemList = List.of(c.itemList ?? [])..insert(0, newPrompt);
        },
        prompt: prompt,
      ),
    );
  }
}
