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
      child: const CustomScrollView(
        slivers: [
          PinnedHeaderSliver(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
              child: _SelectFolderButton(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            sliver: _FileTree(),
          ),
          SliverGap(64.0),
        ],
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
                  cornerRadius: 0.0,
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
            const _RefreshFolderButton(),
          ],
        ),
      ),
    );
  }
}

class _RefreshFolderButton extends AnimatedStatelessWidget {
  const _RefreshFolderButton();

  @override
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.sizeFade(
        child,
        axis: Axis.horizontal,
        layoutBuilder: alignedLayoutBuilder(AlignmentDirectional.centerEnd),
      );

  @override
  Widget buildChild(BuildContext context) {
    final isAnyFolderSelected = context.isAnyFolderSelected();
    if (!isAnyFolderSelected) {
      return const SizedBox.shrink();
    }
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
            tooltip: 'Sync',
            onTap: () {
              final notifier = context.folderNotifier;
              final folderPath = notifier.value;
              notifier.value = null;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                notifier.value = folderPath;
              });
            },
            cornerRadius: 0.0,
            padding: k12HPadding,
            child: Icon(
              HugeIcons.strokeRoundedFolderSync,
              size: 18.0,
              color: PColors.textGray.resolveFrom(context),
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
      onNodeSelected: (context, node, isSelected) =>
          context.handleNodeSelection(node, isSelected),
    );
  }
}
