part of '../snippets_page.dart';

class _SNPSnippetList extends StatelessWidget {
  const _SNPSnippetList();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<_SnippetsController>();
    return InfinityAndBeyond(
      controller: controller,
      padding: k16HPadding,
      itemPadding: k16H4VPadding,
      itemBuilder: (context, index, snippet) => SnippetTile(
        key: ValueKey(
          Object.hash(
            snippet.id,
            controller.sortByNotifier.value,
            snippet.title,
            snippet.content,
          ),
        ),
        snippet: snippet,
        onDelete: () {
          final c = controller.pagingController;
          c.itemList = List.of(c.itemList ?? [])
            ..removeWhere((s) => s.id == snippet.id);
        },
        onExpanded: () async {
          await context.pushRoute(SnippetRoute(id: snippet.id));
          Future.delayed(const Duration(milliseconds: 300), () async {
            if (!context.mounted) return;
            final c = controller.pagingController;
            final newSnippet = await context.db.getSnippet(snippet.id);
            if (!context.mounted) return;
            final index = c.itemList?.indexWhere((s) => s.id == snippet.id);
            if (index == null || index == -1) return;
            c.itemList = List.of(c.itemList ?? [])
              ..removeAt(index)
              ..insert(index, newSnippet);
          });
        },
      ),
    );
  }
}
