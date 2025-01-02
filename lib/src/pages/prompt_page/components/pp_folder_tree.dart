part of '../prompt_page.dart';

class _PPFolderTree extends AnimatedStatelessWidget {
  const _PPFolderTree();

  @override
  Widget buildChild(BuildContext context) {
    if (context.isPromptLoading()) {
      return const SizedBox.shrink();
    }
    final folderPath = context.selectPrompt((p) => p?.folderPath);
    final ignorePatterns = context.selectPrompt((p) => p?.ignorePatterns);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ValueNotifier<String?>>(
          create: (context) => createFolderPathNotifier(context, folderPath),
        ),
        ChangeNotifierProvider<ValueNotifier<IList<String>>>(
          create: (context) => createIgnorePatternsNotifier(
            context,
            ignorePatterns,
          ),
        ),
      ],
      child: StateProvider<FileTreeSortPreferences>(
        createInitialValue: (_) => const FileTreeSortPreferences(),
        child: const _FileTreeContextMenu(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _WebSearchButton()),
              SliverGap(8.0),
              PinnedHeaderSliver(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                  child: _SelectFolderButton(),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                sliver: _FileTree(),
              ),
              // SliverGap(32.0),
              // SliverToBoxAdapter(child: _AddOtherFilesButton()),
              SliverGap(64.0),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Providers & Extensions
// -----------------------------------------------------------------------------

/// Creates a [ValueNotifier] for the folder path associated with the prompt.
/// It automatically updates the prompt in the database when the folder path
/// changes.
ValueNotifier<String?> createFolderPathNotifier(
  BuildContext context,
  String? folderPath,
) {
  final notifier = ValueNotifier(folderPath);
  notifier.addListener(() {
    context.db.updatePrompt(context.prompt!.id, folderPath: notifier.value);
  });
  return notifier;
}

/// Creates a [ValueNotifier] for ignore patterns associated with the prompt.
/// It automatically updates the prompt in the database when the ignore
/// patterns change.
ValueNotifier<IList<String>> createIgnorePatternsNotifier(
  BuildContext context,
  String? ignorePatterns,
) {
  final notifier = ValueNotifier(
    IList(
      ignorePatterns?.split('\n').where((p) => p.trim().isNotEmpty).toList(),
    ),
  );
  notifier.addListener(() {
    context.db.updatePrompt(
      context.prompt!.id,
      ignorePatterns: notifier.value.join('\n'),
    );
  });
  return notifier;
}

extension _LeftSidebarFolderExtension on BuildContext {
  ValueNotifier<String?> get folderNotifier => read<ValueNotifier<String?>>();
  // ValueNotifier<IList<String>> get ignorePatternsNotifier =>
  //     read<ValueNotifier<IList<String>>>();

  String? watchFolderPath() => watch<ValueNotifier<String?>>().value;
  IList<String> watchIgnorePatterns() =>
      watch<ValueNotifier<IList<String>>>().value;

  bool isAnyFolderSelected() =>
      select((ValueNotifier<String?> n) => n.value != null);
}

class _SelectFolderButton extends StatelessWidget {
  const _SelectFolderButton();

  Future<void> _pickFolder(BuildContext context) async {
    final notifier = context.folderNotifier;
    final String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath(initialDirectory: notifier.value);
    if (selectedDirectory != null) {
      notifier.value = selectedDirectory;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.muted;
    final folderPath = context.watchFolderPath();
    final noneSelected = folderPath == null;
    final lightGray = PColors.opaqueLightGray.resolveFrom(context);
    return ClipPath(
      clipper: const ShapeBorderClipper(shape: Superellipse.border8),
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
                  onTap: () => _pickFolder(context),
                  cornerRadius: 12.0,
                  padding: k16H8VPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
            tooltip: _shortcutSpan(context, true, false, 'P'),
            onTap: () => _showFileSearchDialog(context),
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
                  _shortcutSpan(
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
