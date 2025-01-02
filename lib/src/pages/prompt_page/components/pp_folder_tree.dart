part of '../prompt_page.dart';

class _PPFolderTree extends AnimatedStatelessWidget {
  const _PPFolderTree();

  @override
  Widget buildChild(BuildContext context) {
    if (context.isPromptLoading()) {
      return const SizedBox.shrink();
    }
    return StateProvider<FileTreeSortPreferences>(
      createInitialValue: (_) => const FileTreeSortPreferences(),
      child: const _FileTreeContextMenu(
        child: CustomScrollView(
          slivers: [
            SliverGap(4.0),
            SliverToBoxAdapter(
              child: Padding(padding: k4HPadding, child: _WebSearchButton()),
            ),
            SliverGap(8.0),
            PinnedHeaderSliver(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                child: _SelectFolderButton(),
              ),
            ),
            SliverPadding(padding: k4HPadding, sliver: _FileTree()),
            // SliverGap(32.0),
            // SliverToBoxAdapter(child: _AddOtherFilesButton()),
            SliverGap(64.0),
          ],
        ),
      ),
    );
  }
}

class _SelectFolderButton extends StatelessWidget {
  const _SelectFolderButton();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.muted;
    final folderPath = context.watchFolderPath();
    final noneSelected = folderPath == null;
    final lightGray = PColors.opaqueLightGray.resolveFrom(context);
    return Material(
      color: Colors.transparent,
      shape: Superellipse.border8,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 40.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ColoredBox(
                color: lightGray,
                child: CButton(
                  tooltip: 'Change Folder',
                  onTap: context.pickFolder,
                  padding: k16H8VPadding,
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedFolder02,
                            size: 16.0,
                            color: PColors.textGray.resolveFrom(context),
                          ),
                          const Gap(6.0),
                          Flexible(
                            child: TranslationSwitcher.top(
                              duration: Effects.veryShortDuration,
                              child: noneSelected
                                  ? Text(
                                      'Open Folder…',
                                      style: style,
                                      key: const ValueKey(1),
                                    )
                                  : Text(
                                      path.basename(folderPath),
                                      overflow: TextOverflow.ellipsis,
                                      style: style,
                                      key: ValueKey(folderPath),
                                      maxLines: 1,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      TranslationSwitcher.right(
                        layoutBuilder: alignedLayoutBuilder(
                          AlignmentDirectional.centerEnd,
                        ),
                        child: noneSelected
                            ? Text.rich(
                                keyboardShortcutSpan(
                                  context,
                                  true,
                                  false,
                                  'O',
                                  PColors.darkGray.resolveFrom(context),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const _SearchFolderButton(),
          ],
        ),
      ),
    );
  }
}

class _SearchFolderButton extends AnimatedStatelessWidget {
  const _SearchFolderButton();

  @override
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.sizeFade(
        child,
        axis: Axis.horizontal,
        layoutBuilder: alignedLayoutBuilder(AlignmentDirectional.centerStart),
      );

  @override
  Widget buildChild(BuildContext context) {
    final isAnyFolderSelected = context.isAnyFolderSelected();
    if (!isAnyFolderSelected) return const SizedBox.shrink();
    final lightGray = PColors.opaqueLightGray.resolveFrom(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VerticalDivider(
          width: 1.0,
          thickness: 1.0,
          color: lightGray.withOpacityFactor(.5),
        ),
        ColoredBox(
          color: lightGray,
          child: CButton(
            tooltip: keyboardShortcutSpan(context, true, false, 'P'),
            onTap: () => _showPathSearchDialog(context),
            cornerRadius: 12.0,
            padding: k12HPadding,
            child: Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedSearch01,
                  size: 18.0,
                  color: PColors.textGray.resolveFrom(context),
                ),
                const Gap(4.0),
                Text.rich(
                  keyboardShortcutSpan(
                    context,
                    true,
                    false,
                    'P',
                    PColors.darkGray.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FileTree extends StatelessWidget {
  const _FileTree();

  @override
  Widget build(BuildContext context) {
    return FileTree(
      dirPath: context.watchFolderPath(),
      ignorePatterns: context.watchIgnorePatterns(),
      countSelection: (context, item) => context.countSelection(item.path),
      sortPreferences: context.watch(),
    );
  }
}

class _FileTreeContextMenu extends StatelessWidget {
  const _FileTreeContextMenu({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sortPreferences = context.watch<FileTreeSortPreferences>();
    final sortOption = sortPreferences.sortOption;

    void update(FileTreeSortPreferences preferences) {
      context.read<ValueNotifier<FileTreeSortPreferences>>().value =
          preferences;
    }

    const check = ShadImage.square(LucideIcons.check, size: 16);

    return ShadContextMenuRegion(
      constraints: const BoxConstraints(minWidth: 200.0),
      items: [
        ShadContextMenuItem(
          trailing: const ShadImage.square(
            LucideIcons.chevronRight,
            size: 16,
          ),
          items: [
            ...FileTreeSortOption.values.map(
              (option) => ShadContextMenuItem(
                trailing: option == sortOption ? check : null,
                onPressed: () => update(
                  sortPreferences.copyWith(sortOption: option),
                ),
                child: Text(option.label),
              ),
            ),
            const Divider(height: 8),
            ShadContextMenuItem(
              trailing: sortPreferences.ascending ? check : null,
              onPressed: () => update(
                sortPreferences.copyWith(ascending: !sortPreferences.ascending),
              ),
              child: const Text('Ascending'),
            ),
            ShadContextMenuItem(
              trailing: sortPreferences.foldersFirst ? check : null,
              onPressed: () => update(
                sortPreferences.copyWith(
                  foldersFirst: !sortPreferences.foldersFirst,
                ),
              ),
              child: const Text('Folders First'),
            ),
          ],
          child: const Text('Sort by'),
        ),
        ShadContextMenuItem(
          onPressed: () async {
            final selectedPaths =
                await FilePicker.platform.pickFiles(allowMultiple: true);
            if (!context.mounted) return;
            if (selectedPaths != null) {
              for (final path in selectedPaths.paths) {
                if (path == null) continue;
                await _handleNodeSelection(
                  context,
                  reloadNode: true,
                  fullPath: path,
                  isSelected: true,
                );
              }
            }
          },
          trailing: const ShadImage.square(LucideIcons.filePlus, size: 16),
          child: const Text('Add Other Files…'),
        ),
      ],
      child: child,
    );
  }
}
