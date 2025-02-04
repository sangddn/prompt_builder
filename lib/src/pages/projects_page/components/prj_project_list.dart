part of '../projects_page.dart';

class _PRJProjectList extends StatelessWidget {
  const _PRJProjectList();

  @override
  Widget build(BuildContext context) {
    final controller = context.controller;
    return InfinityAndBeyond<Project>(
      controller: controller,
      itemPadding: k16H8VPadding,
      itemBuilder: (context, index, project) => ProjectCard(
        key: ValueKey(Object.hash(project, controller.sortByNotifier.value)),
        onTap: () async {
          await context.pushProjectRoute(id: project.id);
          Future.delayed(const Duration(milliseconds: 300), () async {
            if (!context.mounted) return;
            await controller.reloadProject(context, project.id);
          });
        },
        onDelete: () {
          controller.onProjectDeleted(project.id);
        },
        project: project,
      ),
    );
  }
}
