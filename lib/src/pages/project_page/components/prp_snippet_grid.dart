part of '../project_page.dart';

class _PRPSnippetGrid extends StatelessWidget {
  const _PRPSnippetGrid();

  @override
  Widget build(BuildContext context) {
    if (!context.isReady()) {
      return const SliverToBoxAdapter(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    final controller = context.read<SnippetListController>();
    return SliverVisibility(
      visible: context.snippetGridIsExpanded(),
      maintainState: true,
      sliver: SnippetList(
        controller: controller,
        showProjectName: false,
        areSnippetsCollapsed: true,
      ),
    );
  }
}

class _PRPSnippetGridTitle extends StatelessWidget {
  const _PRPSnippetGridTitle();

  @override
  Widget build(BuildContext context) => SliverList.list(
    children: [
      Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Snippets', style: context.textTheme.h3),
                const Gap(16.0),
                Builder(
                  builder: (context) {
                    final isExpanded = context.snippetGridIsExpanded();
                    return ShadButton.ghost(
                      onPressed: context.toggleSnippetGrid,
                      size: ShadButtonSize.sm,
                      icon: Transform.rotate(
                        angle: isExpanded ? math.pi : 0.0,
                        child: const Icon(LucideIcons.chevronDown, size: 16.0),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ShadButton.ghost(
            onPressed: () async {
              final db = context.read<Database>();
              final id = await db.createSnippet(projectId: context.project!.id);
              if (!context.mounted) return;
              context.toggleSnippetGrid(_SnippetGridState.expanded);
              await context.read<SnippetListController>().onSnippetCreated(
                context,
                id,
              );
            },
            size: ShadButtonSize.sm,
            icon: const Icon(LucideIcons.plus, size: 16.0),
          ),
        ],
      ),
      const Gap(16.0),
      TagFilterBar(
        notifier: context.read<_SnippetTagNotifier>(),
        type: TagType.snippet,
        projectId: context.read<ProjectIdNotifier>().value,
      ),
    ],
  );
}
