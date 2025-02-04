import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/core.dart';
import '../../database/database.dart';
import '../components.dart';

class ProjectCard extends MultiProviderWidget {
  const ProjectCard({required this.onTap, required this.project, super.key});

  final VoidCallback? onTap;
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
      leading: const ProjectIcon(),
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
              '${project.updatedAt != null && project.updatedAt != project.createdAt ? 'Updated ${timeAgo(project.updatedAt!).toLowerCase()} • ' : ''}Created ${timeAgo(project.createdAt).toLowerCase()}',
            ),
          ],
        ),
      ),
      isThreeLine: project.notes.isNotEmpty,
      visualDensity: VisualDensity.comfortable,
      shape: Superellipse.border16,
      tileColor: PColors.lightGray.resolveFrom(context),
      splashColor: Colors.transparent,
      onTap: onTap,
    );
  }
}

class ProjectIcon extends StatelessWidget {
  const ProjectIcon({
    this.size = 18.0,
    this.padding = k8APadding,
    super.key,
  });

  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final project = context.watch<Project>();
    final color = project.color?.let((it) => Color(it)) ??
        theme.primaryButtonTheme.backgroundColor!;
    final child = project.emoji != null
        ? Text(project.emoji!, style: TextStyle(fontSize: size))
        : ShadImage.square(LucideIcons.folder, size: size, color: color);
    return Container(
      decoration: BoxDecoration(
        color: color.replaceOpacity(0.1),
        shape: BoxShape.circle,
      ),
      padding: padding,
      child: child,
    );
  }
}
