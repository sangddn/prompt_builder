part of '../snippets_page.dart';

class _SNPAppBar extends StatelessWidget {
  const _SNPAppBar();

  @override
  Widget build(BuildContext context) {
    return const PAppBar(
      title: Text('Snippets'),
      actions: [_SortButton(), _SPAddSnippetButton()],
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    final sortByNotifier = context.watch<_SortByNotifier>();
    final (sortBy, ascending) = sortByNotifier.value;

    return ContextMenuButton(
      items: [
        ...SnippetSortBy.values.map(
          (e) => MenuButton(
            title: Text(e.title),
            trailingGap: 16.0,
            trailing: sortBy == e
                ? const Icon(CupertinoIcons.checkmark, size: 16.0)
                : const Icon(null, size: 16.0),
            onPressed: () => sortByNotifier.value = (e, ascending),
          ),
        ),
        Divider(
          height: 16.0,
          thickness: 0.5,
          color: PColors.lightGray.resolveFrom(context),
        ),
        Padding(
          padding: k12H4VPadding,
          child: ShadSwitch(
            value: ascending,
            onChanged: (v) => sortByNotifier.value = (sortBy, v),
            label: const Text('Ascending'),
          ),
        ),
        const Gap(8.0),
      ],
      overlayPosition: (_, __) => FeedbackOverlayPosition.start,
      builder: (context, open) => ShadButton.ghost(
        onPressed: open,
        size: ShadButtonSize.sm,
        icon: Icon(
          ascending ? CupertinoIcons.sort_up : CupertinoIcons.sort_down,
          size: 16.0,
        ),
      ),
    );
  }
}

extension _SortByInformation on SnippetSortBy {
  String get title => switch (this) {
        SnippetSortBy.createdAt => 'Creation Date',
        SnippetSortBy.updatedAt => 'Last Updated',
        SnippetSortBy.lastUsedAt => 'Last Used',
        SnippetSortBy.title => 'Title',
      };
}
