part of '../snippets_page.dart';

class _SPAddSnippetButton extends StatelessWidget {
  const _SPAddSnippetButton();

  @override
  Widget build(BuildContext context) {
    return ShadButton.ghost(
      onPressed: () async {
        final db = context.read<Database>();
        await db.createSnippet();
        if (!context.mounted) return;
        context.read<_SnippetsController>()._refresh();
        context.read<_SortByNotifier>().value =
            (SnippetSortBy.createdAt, false);
      },
      size: ShadButtonSize.sm,
      icon: const Icon(LucideIcons.plus, size: 16.0),
    );
  }
}
