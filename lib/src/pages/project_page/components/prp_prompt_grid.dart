part of '../project_page.dart';

class _PRPPromptGrid extends StatelessWidget {
  const _PRPPromptGrid();

  @override
  Widget build(BuildContext context) {
    if (!context.isReady()) {
      return const SliverToBoxAdapter(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    return PromptGrid(
      controller: context.read<PromptGridController>(),
      showProjectName: false,
    );
  }
}

class _PRPPromptGridTitle extends StatelessWidget {
  const _PRPPromptGridTitle();

  @override
  Widget build(BuildContext context) => SliverList.list(
        children: [
          Row(
            children: [
              Expanded(child: Text('Prompts', style: context.textTheme.h3)),
              ShadButton.ghost(
                onPressed: () async {
                  final db = context.read<Database>();
                  final id =
                      await db.createPrompt(projectId: context.project!.id);
                  if (!context.mounted) return;
                  final c = context.read<PromptGridController>();
                  context.pushPromptRoute(id: id);
                  await c.onPromptAdded(id);
                },
                size: ShadButtonSize.sm,
                icon: const Icon(LucideIcons.plus, size: 16.0),
              ),
            ],
          ),
          const Gap(16.0),
          TagFilterBar(
            notifier: context.read<_PromptTagNotifier>(),
            type: TagType.prompt,
            projectId: context.read<ProjectIdNotifier>().value,
          ),
        ],
      );
}
