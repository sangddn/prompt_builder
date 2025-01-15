part of '../snippets_page.dart';

class _SPAddSnippetButton extends StatelessWidget {
  const _SPAddSnippetButton();

  @override
  Widget build(BuildContext context) {
    return ShadButton.ghost(
      onPressed: () async {
        final db = context.read<Database>();
        final id = await db.createSnippet();
        final snippet = await db.getSnippet(id);
        if (!context.mounted) return;
        final c = context.read<_SnippetsController>().pagingController;
        c.itemList = List.of(c.itemList ?? [])..insert(0, snippet);
        context.read<_SortByNotifier>().value =
            (SnippetSortBy.createdAt, false);
      },
      size: ShadButtonSize.sm,
      icon: const Icon(LucideIcons.plus, size: 16.0),
    );
  }
}
