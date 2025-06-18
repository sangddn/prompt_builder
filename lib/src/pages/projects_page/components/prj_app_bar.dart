part of '../projects_page.dart';

class _PRJAppBar extends StatelessWidget {
  const _PRJAppBar();

  @override
  Widget build(BuildContext context) {
    return const PAppBar(
      title: Text('Projects'),
      actions: [_SortButton(), _PRJAddProjectButton()],
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    final sortByNotifier = context.watch<ProjectSortByNotifier>();
    final (sortBy, ascending, starredOnly, prioritizeStarred) =
        sortByNotifier.value;

    return ContextMenuButton(
      items: [
        ...ProjectSortBy.values.map(
          (e) => MenuButton(
            title: Text(e.title),
            trailingGap: 16.0,
            trailing:
                sortBy == e
                    ? const Icon(CupertinoIcons.checkmark, size: 16.0)
                    : const Icon(null, size: 16.0),
            onPressed:
                () =>
                    sortByNotifier.value = (
                      e,
                      ascending,
                      starredOnly,
                      prioritizeStarred,
                    ),
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
            onChanged:
                (v) =>
                    sortByNotifier.value = (
                      sortBy,
                      v,
                      starredOnly,
                      prioritizeStarred,
                    ),
            label: const Text('Ascending'),
          ),
        ),
        const Gap(8.0),
      ],
      overlayPosition: (_, __) => FeedbackOverlayPosition.start,
      builder:
          (context, open) => ShadButton.ghost(
            onPressed: open,
            size: ShadButtonSize.sm,
            child: Icon(
              ascending ? CupertinoIcons.sort_up : CupertinoIcons.sort_down,
              size: 16.0,
            ),
          ),
    );
  }
}

extension _SortByInformation on ProjectSortBy {
  String get title => switch (this) {
    ProjectSortBy.createdAt => 'Creation Date',
    ProjectSortBy.updatedAt => 'Last Updated',
    ProjectSortBy.title => 'Title',
  };
}
