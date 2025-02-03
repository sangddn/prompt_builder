part of '../projects_page.dart';

class _PRJProjectList extends StatelessWidget {
  const _PRJProjectList();

  @override
  Widget build(BuildContext context) {
    return InfinityAndBeyond<Project>(
      controller: context.controller,
      itemPadding: k16H8VPadding,
      itemBuilder: (context, index, project) => ProjectCard(project: project),
    );
  }
}
