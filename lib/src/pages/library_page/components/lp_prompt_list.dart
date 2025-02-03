part of '../library_page.dart';

class _LPPromptList extends StatelessWidget {
  const _LPPromptList();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<_LibraryController>();
    return Provider<Map<String, GlobalKey>>(
      create: (_) => {},
      child: InfinityAndBeyond.grid(
        controller: controller,
        childAspectRatio: 3.5 / 4,
        maxCrossAxisExtent: 300.0,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        itemBuilder: (context, index, prompt) => PromptTile(
          key: context.read<Map<String, GlobalKey>>().putIfAbsent(
                '${prompt.id}-${controller.sortByNotifier.value}',
                () => GlobalKey(),
              ),
          db: context.db,
          onTap: () => context.pushRoute(PromptRoute(id: prompt.id)),
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
      ),
    );
  }
}
