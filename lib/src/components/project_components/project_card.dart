import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../app.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../components.dart';

class ProjectCard extends MultiProviderWidget {
  const ProjectCard({
    required this.onTap,
    this.onDelete,
    required this.project,
    super.key,
  });

  final VoidCallback? onTap, onDelete;
  final Project project;

  @override
  List<SingleChildWidget> get providers => [
        Provider.value(value: project),
      ];

  @override
  Widget buildChild(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;
    return _ContextMenu(
      project: project,
      onDelete: onDelete,
      child: ListTile(
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
      ),
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

class _ContextMenu extends StatelessWidget {
  const _ContextMenu({
    required this.project,
    required this.onDelete,
    required this.child,
  });

  final Project project;
  final VoidCallback? onDelete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShadContextMenuRegion(
      constraints: const BoxConstraints(minWidth: 200.0, maxWidth: 300.0),
      items: [
        ShadContextMenuItem(
          onPressed: () async {
            await context.db.deleteProject(project.id);
            onDelete?.call();
          },
          trailing: const ShadImage.square(LucideIcons.trash, size: 16),
          child: const Text('Delete'),
        ),
      ],
      child: child,
    );
  }
}
