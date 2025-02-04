import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';
import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../../router/router.dart';
import '../../components.dart';

part 'project_list_controller.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({required this.controller, super.key});

  final ProjectListController controller;

  @override
  Widget build(BuildContext context) {
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
        onStarred: (isStarred) async {
          final v = controller.sortByNotifier.value;
          final starredOnly = v.$3;
          final prioritizeStarred = v.$4;
          if (starredOnly == null) {
            await controller.reloadProject(context, project.id);
            if (!context.mounted) return;
            if (prioritizeStarred && isStarred) {
              // Move to the top of the list
              controller.moveToTop(project.id);
              return;
            }
            if (prioritizeStarred && !isStarred) {
              // Move to the after the last starred project
              controller.moveToAfterLastStarredProject(project.id);
              return;
            }
            return;
          }
          if (starredOnly && !isStarred) {
            controller.onProjectDeleted(project.id);
            return;
          }
          if (!starredOnly && isStarred) {
            controller.onProjectDeleted(project.id);
            return;
          }
          return;
        },
        project: project,
      ),
    );
  }
}
