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
        key: ValueKey(snippet.id),
        database: context.read<Database>(),
        snippet: snippet,
        onDelete: () {
          final c = controller.pagingController;
          c.itemList = List.of(c.itemList ?? [])
            ..removeWhere((s) => s.id == snippet.id);
        },
      ),
    );
  }
}
