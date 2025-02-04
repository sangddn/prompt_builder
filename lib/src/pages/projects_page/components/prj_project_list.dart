part of '../projects_page.dart';

class _PRJProjectList extends StatelessWidget {
  const _PRJProjectList();

  @override
  Widget build(BuildContext context) {
    final controller = context.controller;
    return ProjectList(controller: controller);
  }
}
