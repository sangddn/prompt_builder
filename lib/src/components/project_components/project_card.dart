import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/core.dart';
import '../../database/database.dart';
import '../../router/router.gr.dart';
import '../components.dart';

class ProjectCard extends MultiProviderWidget {
  const ProjectCard({required this.project, super.key});

  final Project project;

  @override
  List<SingleChildWidget> get providers => [
        Provider.value(value: project),
      ];

  @override
  Widget buildChild(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;
    return ListTile(
      leading: const _Leading(),
      title: Text(
        project.title.isEmpty ? 'Untitled' : project.title,
        style: textTheme.p,
      ),
      subtitle: DefaultTextStyle(
        style: textTheme.muted,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.notes.isNotEmpty) Text(project.notes),
            Text(
              '${project.updatedAt != null && project.updatedAt != project.createdAt ? 'Updated ${timeAgo(project.updatedAt!)} • ' : ''}Created ${timeAgo(project.createdAt)}',
            ),
          ],
        ),
      ),
      isThreeLine: project.notes.isNotEmpty,
      visualDensity: VisualDensity.comfortable,
      shape: Superellipse.border16,
      tileColor: PColors.lightGray.resolveFrom(context),
      splashColor: Colors.transparent,
      onTap: () {
        context.pushRoute(ProjectRoute(id: project.id));
      },
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final project = context.watch<Project>();
    final color = project.color?.let((it) => Color(it)) ??
        theme.primaryButtonTheme.backgroundColor!;
    final child = project.emoji != null
        ? Text(project.emoji!, style: const TextStyle(fontSize: 20.0))
        : ShadImage.square(LucideIcons.folder, size: 18.0, color: color);
    return Container(
      decoration: BoxDecoration(
        color: color.replaceOpacity(0.1),
        shape: BoxShape.circle,
      ),
      padding: k8APadding,
      child: child,
    );
  }
}
