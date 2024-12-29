part of 'file_tree.dart';

class SelectableFileTreeItem extends StatelessWidget {
  const SelectableFileTreeItem({
    this.selectionCount = 0,
    this.onItemSelected,
    required this.node,
    super.key,
  });

  final int selectionCount;
  final ValueChanged<bool>? onItemSelected;
  final IndexedFileTree node;

  @override
  Widget build(BuildContext context) {
    final item = node.data;
    if (item == null) return const SizedBox.shrink();
    return MultiProvider(
      providers: [
        ListenableProvider<IndexedTreeNode<FileTreeItem>>.value(value: node),
        ChangeNotifierProvider<ValueNotifier<bool>>.value(
          value: node.expansionNotifier,
        ),
        Provider<ValueChanged<bool>?>.value(value: onItemSelected),
        Provider<int>.value(value: selectionCount),
      ],
      child: const _ItemContextMenu(
        child: _ItemPreviewer(child: _ItemContent()),
      ),
    );
  }
}

extension _FileTreeItemContext on BuildContext {
  T selectNode<T>(T Function(IndexedFileTree node) fn) => select(fn);
  FileTreeItem item() => selectNode((node) => node.data!);
  bool isDirectory() => selectNode((node) => node.data!.isDirectory);
  bool isExpanded() => watch<ValueNotifier<bool>>().value;

  int countAllFilesContained() {
    final thisPath = item().path;
    return select(
      ((IList<String>, IList<String>) paths) => paths.$1.where((p) {
        return p.startsWith(thisPath) && path.extension(p).trim().isNotEmpty;
      }).length,
    );
  }

  void selectOrDeselect() {
    final count = read<int>();
    final shouldSelect = count == 0;
    read<ValueChanged<bool>?>()?.call(shouldSelect);
  }
}

class _ItemContent extends StatelessWidget {
  const _ItemContent();

  @override
  Widget build(BuildContext context) {
    final item = context.item();
    final isDirectory = item.isDirectory;
    return ListTile(
      splashColor: Colors.transparent,
      shape: Superellipse.border8,
      // For directory, avoids chevron on the right
      contentPadding:
          EdgeInsets.only(left: 12.0, right: isDirectory ? 26.0 : 6.0),
      leading: const _ItemIcon(),
      onTap: () {
        if (isDirectory) {
          context
              .read<FileTreeController?>()
              ?.toggleExpansion(context.read<IndexedFileTree>());
        } else {
          peekFile(context, item.path);
        }
      },
      title: Text(
        item.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
      trailing: const _ItemTrailing(),
    );
  }
}

class _ItemIcon extends StatelessWidget {
  const _ItemIcon();

  @override
  Widget build(BuildContext context) {
    final isDirectory = context.isDirectory();
    final isExpanded = context.isExpanded();
    final isSelected = context.select((int count) => count > 0);
    return Icon(
      isDirectory
          ? isExpanded
              ? HugeIcons.strokeRoundedFolder03
              : isSelected
                  ? HugeIcons.strokeRoundedFolderCheck
                  : HugeIcons.strokeRoundedFolder01
          : isSelected
              ? HugeIcons.strokeRoundedFileVerified
              : HugeIcons.strokeRoundedFile01,
      color: isSelected ? context.colorScheme.primary : null,
      size: 18.0,
    );
  }
}

class _ItemTrailing extends StatelessWidget {
  const _ItemTrailing();

  @override
  Widget build(BuildContext context) {
    final isHovered = context.isSimpleOrLongHovered();
    if (isHovered) return const _AddButton();
    final count = context.watch<int>();
    if (count == 0) return const SizedBox.shrink();
    if (context.isDirectory()) {
      return ShadBadge(
        backgroundColor: context.colorScheme.accent,
        foregroundColor: context.colorScheme.accentForeground,
        child: Text('$count'),
      );
    }
    return ShadImage.square(
      CupertinoIcons.checkmark_alt_circle,
      size: 20.0,
      color: context.colorScheme.accentForeground,
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    final isDirectory = context.isDirectory();
    final selectionCount = context.watch<int>();
    final isSelected = selectionCount > 0;
    final theme = context.theme;
    final color = PColors.opaqueLightGray.resolveFrom(context);
    return Material(
      color: Colors.transparent,
      shape: Superellipse.border8,
      clipBehavior: Clip.antiAlias,
      child: HoverTapBuilder(
        onClicked: context.selectOrDeselect,
        builder: (context, isHovered) {
          return Container(
            color: isHovered
                ? theme.resolveColor(color.tint(.7), color.tint(.1))
                : color,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: DefaultTextStyle(
              style: context.textTheme.small,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShadImage.square(
                    isSelected ? CupertinoIcons.minus : CupertinoIcons.plus,
                    size: 12.0,
                  ),
                  const Gap(4.0),
                  if (isSelected)
                    if (isDirectory)
                      const Text('Remove all')
                    else
                      const Text('Remove')
                  else if (isDirectory)
                    const Text('Add all')
                  else
                    const Text('Add'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ItemContextMenu extends StatelessWidget {
  const _ItemContextMenu({
    required this.child,
  });

  final Widget child;

  Future<void> _revealInFinder(
    BuildContext context,
    String absolutePath,
  ) async {
    final toaster = context.toaster;
    try {
      await revealInFinder(absolutePath);
    } catch (e) {
      debugPrint('Could not reveal file: $e');
      toaster.show(
        ShadToast.destructive(
          title: const Text('Could not reveal file'),
          description: Text(absolutePath),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = context.selectNode((n) => n.data!.path);
    final isDirectory = context.selectNode((n) => n.data!.isDirectory);
    return ShadContextMenuRegion(
      constraints: const BoxConstraints(minWidth: 200),
      items: [
        Builder(
          builder: (context) {
            final selectionCount = context.watch<int>();
            return ShadContextMenuItem(
              onPressed: context.selectOrDeselect,
              trailing: ShadImage.square(
                selectionCount == 0
                    ? HugeIcons.strokeRoundedAdd01
                    : HugeIcons.strokeRoundedRemove01,
                size: 16.0,
              ),
              child: Text(
                selectionCount == 0
                    ? 'Add ${context.countAllFilesContained()} files'
                    : 'Remove $selectionCount files',
              ),
            );
          },
        ),
        if (!isDirectory)
          ShadContextMenuItem(
            onPressed: () => peekFile(context, path),
            trailing: const ShadImage.square(
              HugeIcons.strokeRoundedEye,
              size: 16.0,
            ),
            child: const Text('Peek'),
          ),
        ShadContextMenuItem(
          onPressed: () => _revealInFinder(context, path),
          trailing: const ShadImage.square(
            HugeIcons.strokeRoundedAppleFinder,
            size: 16.0,
          ),
          child: const Text('Reveal in Finder'),
        ),
      ],
      child: child,
    );
  }
}
