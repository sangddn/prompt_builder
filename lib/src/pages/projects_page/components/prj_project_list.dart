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
        project: project,
      ),
    );
  }
}
