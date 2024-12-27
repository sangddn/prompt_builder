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
}

class _ItemContent extends StatelessWidget {
  const _ItemContent();

  @override
  Widget build(BuildContext context) {
    final (item, isExpanded) =
        context.selectNode((node) => (node.data!, node.isExpanded));
    final isDirectory = item.isDirectory;
    return ListTile(
      splashColor: Colors.transparent,
      shape: Superellipse.border8,
      // For directory, avoids chevron on the right
      contentPadding:
          EdgeInsets.only(left: 12.0, right: isDirectory ? 26.0 : 6.0),
      leading: Icon(
        isDirectory
            ? isExpanded
                ? HugeIcons.strokeRoundedFolder03
                : HugeIcons.strokeRoundedFolder01
            : HugeIcons.strokeRoundedFile01,
        size: 18.0,
      ),
      onTap: () {
        context
            .read<FileTreeController?>()
            ?.toggleExpansion(context.read<IndexedFileTree>());
      },
      title: Text(
        item.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
      trailing: context.isSimpleOrLongHovered() ? const _AddButton() : null,
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    final isDirectory = context.selectNode((n) => n.data!.isDirectory);
    final selectionCount = context.watch<int>();
    final isSelected = selectionCount > 0;
    final color = PColors.opaqueLightGray.resolveFrom(context);
    return Material(
      color: Colors.transparent,
      shape: Superellipse.border8,
      clipBehavior: Clip.antiAlias,
      child: HoverTapBuilder(
        onClicked: () {
          final shouldSelect = selectionCount == 0;
          context.read<ValueChanged<bool>?>()?.call(shouldSelect);
        },
        builder: (context, isHovered) {
          return Container(
            color: isHovered ? color.tint(0.1) : color,
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
        const ShadToast.destructive(title: Text('Could not reveal file')),
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
