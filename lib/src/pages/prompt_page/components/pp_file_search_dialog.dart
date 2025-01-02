part of '../prompt_page.dart';

Future<void> _showFileSearchDialog(BuildContext context) => showPDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => MultiProvider(
        providers: [
          Provider<_PathSearchCallback>.value(value: context.read()),
          Provider<int Function(String)>.value(
            value: (p) => context
                .read<_SelectedFilePaths>()
                .where((e) => e.startsWith(p))
                .length,
          ),
        ],
        child: NotificationListener<NodeSelectionNotification>(
          onNotification: (n) {
            // Forward the notification from dialog to the main context.
            n.dispatch(context);
            return true;
          },
          child: const _PPFileSearchDialog(),
        ),
      ),
    );

/// Type signature of the notifier that holds the search results.
typedef _FileSearchNotifier = ValueNotifier<_FileSearchResults>;

/// Type signature of the search results.
/// The first element is the full path, the second element is the relative path,
/// and the third element is a boolean indicating whether the path is a directory.
typedef _FileSearchResults = IList<(String, String, bool)>;

enum _FileSearchState {
  idle,
  searching,
}

class _PPFileSearchDialog extends StatelessWidget {
  const _PPFileSearchDialog();

  @override
  Widget build(BuildContext context) {
    return StateProvider<_FileSearchResults>(
      createInitialValue: (_) => const IList.empty(),
      child: StateProvider<_FileSearchState>(
        createInitialValue: (_) => _FileSearchState.idle,
        child: ValueProvider<TextEditingController>(
          create: (_) => TextEditingController(),
          onNotified: (context, controller) async {
            if (controller?.text case final text?) {
              final stateNotifier =
                  context.read<ValueNotifier<_FileSearchState>>();
              final notifier = context.read<_FileSearchNotifier>();
              stateNotifier.value = _FileSearchState.searching;
              final results = (await context.read<_PathSearchCallback>()(text))
                  .take(20)
                  .toIList();
              if (!context.mounted) return;
              stateNotifier.value = _FileSearchState.idle;
              // By the time the search results are ready, the text may have changed.
              // If so, we don't want to update the search results.
              if (text == controller?.text) {
                notifier.value = results;
              }
            }
          },
          builder: (context, child) =>
              ProxyProvider<TextEditingController, List<String>>(
            update: (_, controller, __) => controller.text
                .toLowerCase()
                .split(' ')
                .where((element) => element.length >= 3)
                .toList(),
            child: child,
          ),
          child: Align(
            alignment: const Alignment(0.0, -0.4),
            child: Container(
              decoration: ShapeDecoration(
                color: context.colorScheme.popover,
                shape: Superellipse(
                  cornerRadius: 12.0,
                  side: BorderSide(
                    width: .15,
                    color: PColors.opagueGray.resolveFrom(context),
                  ),
                ),
                shadows: [
                  ...mediumShadows(),
                  BoxShadow(
                    color: Colors.black.replaceOpacity(.1),
                    blurRadius: 48.0,
                    spreadRadius: 8.0,
                  ),
                ],
              ),
              width: 600.0,
              height: 500.0,
              clipBehavior: Clip.hardEdge,
              child: const Material(
                color: Colors.transparent,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    PinnedHeaderSliver(
                      child: Column(
                        children: [
                          _FileSearchField(),
                          Divider(height: 1.0, thickness: 1.0),
                        ],
                      ),
                    ),
                    SliverGap(8.0),
                    _FileSearchResultList(),
                    SliverGap(32.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FileSearchField extends StatelessWidget {
  const _FileSearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read(),
      autofocus: true,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Builder(
            builder: (context) {
              final isLoading = context.watch<_FileSearchState>() ==
                  _FileSearchState.searching;
              return GrayShimmer(
                enableShimmer: isLoading,
                child: const Icon(
                  HugeIcons.strokeRoundedFolderSearch,
                  size: 20.0,
                ),
              );
            },
          ),
        ),
        hintText: 'Search files…',
        border: InputBorder.none,
        filled: true,
        fillColor: context.colorScheme.popover,
        contentPadding: k24APadding,
      ),
      style: context.textTheme.list,
    );
  }
}

class _FileSearchResultList extends StatelessWidget {
  const _FileSearchResultList();

  @override
  Widget build(BuildContext context) {
    final count = context.select((_FileSearchNotifier n) => n.value.length);
    return SuperSliverList.builder(
      itemCount: count,
      itemBuilder: (context, index) => Builder(
        builder: (context) {
          final info =
              context.select((_FileSearchNotifier n) => n.value[index]);
          return _FileSearchResult(info, key: ValueKey(info.$1));
        },
      ),
    );
  }
}

class _FileSearchResult extends StatelessWidget {
  const _FileSearchResult(this.info, {super.key});

  final (String, String, bool) info;

  @override
  Widget build(BuildContext context) {
    final highlights = context.watch<List<String>>();
    final (fullPath, relativePath, isDirectory) = info;

    return HoverTapBuilder(
      builder: (context, isHovered) {
        final trailing = StatefulBuilder(
          builder: (context, setState) {
            final selectionCount =
                context.read<int Function(String)>()(fullPath);
            Future<void> addOrRemove() async {
              NodeSelectionNotification(fullPath, selectionCount == 0)
                  .dispatch(context);
              setState(() {});
            }

            if (selectionCount > 0) {
              if (isHovered) {
                return ShadBadge.destructive(
                  onPressed: addOrRemove,
                  child: Text(
                    isDirectory ? 'Remove $selectionCount files' : 'Remove',
                  ),
                );
              }
              return ShadBadge.secondary(
                child: Text(
                  isDirectory ? '$selectionCount added' : 'Added',
                ),
              );
            }
            final text = Text(isDirectory ? 'Add all' : 'Add');
            if (isHovered) {
              return ShadBadge(
                onPressed: addOrRemove,
                child: text,
              );
            }
            return ShadBadge.secondary(
              onPressed: addOrRemove,
              child: text,
            );
          },
        );

        return ShadContextMenuRegion(
          constraints: const BoxConstraints(minWidth: 200),
          items: [
            if (!isDirectory)
              ShadContextMenuItem(
                onPressed: () => peekFile(context, fullPath),
                trailing: const ShadImage.square(
                  HugeIcons.strokeRoundedEye,
                  size: 16.0,
                ),
                child: const Text('Peek'),
              ),
            ShadContextMenuItem(
              onPressed: () => revealInFinder(fullPath),
              trailing: const ShadImage.square(
                HugeIcons.strokeRoundedAppleFinder,
                size: 16.0,
              ),
              child: const Text('Reveal in Finder'),
            ),
          ],
          child: ListTile(
            leading: ShadImage.square(
              isDirectory
                  ? HugeIcons.strokeRoundedFolder01
                  : HugeIcons.strokeRoundedFile01,
              size: 16.0,
            ),
            title: HighlightedText(
              text: path.basename(relativePath),
              highlights: highlights,
              caseSensitive: false,
            ),
            subtitle: HighlightedText(
              text: relativePath,
              highlights: highlights,
              caseSensitive: false,
            ),
            splashColor: Colors.transparent,
            onTap: () => isDirectory
                ? revealInFinder(fullPath)
                : peekFile(context, fullPath),
            trailing: trailing,
          ),
        );
      },
    );
  }
}
