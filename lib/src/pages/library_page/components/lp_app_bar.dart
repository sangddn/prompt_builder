part of '../library_page.dart';

class _LPAppBar extends StatelessWidget {
  const _LPAppBar();

  @override
  Widget build(BuildContext context) {
    return const PAppBar(
      title: Text('Library'),
      actions: [_ImportButton(), _SortButton()],
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    final sortByNotifier = context.watch<PromptSortByNotifier>();
    final (sortBy, ascending) = sortByNotifier.value;
    final projectIdNotifier = context.watch<ProjectIdNotifier>();
    final hasProject = !projectIdNotifier.value.present;

    return ContextMenuButton(
      items: [
        ...PromptSortBy.values.map(
          (e) => MenuButton(
            title: Text(e.title),
            trailingGap: 16.0,
            trailing:
                sortBy == e
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
        Padding(
          padding: k12H4VPadding,
          child: ShadSwitch(
            value: !hasProject,
            onChanged:
                (v) =>
                    projectIdNotifier.value =
                        v ? const Value(null) : const Value.absent(),
            label: const Text('No Project Only'),
          ),
        ),
        const Gap(8.0),
      ],
      overlayPosition: (_, _) => FeedbackOverlayPosition.start,
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

extension _SortByInformation on PromptSortBy {
  String get title => switch (this) {
    PromptSortBy.createdAt => 'Creation Date',
    PromptSortBy.updatedAt => 'Last Updated',
    PromptSortBy.lastOpened => 'Last Opened',
    PromptSortBy.title => 'Title',
  };
}

class _ImportButton extends StatelessWidget {
  const _ImportButton();

  @override
  Widget build(BuildContext context) {
    return ShadButton.ghost(
      onPressed: () async {
        await importPrompt(context, context.db);
      },
      size: ShadButtonSize.sm,
      child: const Icon(LucideIcons.import, size: 16.0),
    );
  }
}
