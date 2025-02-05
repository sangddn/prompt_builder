import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../app.dart';
import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../../router/router.dart';
import '../../../services/services.dart';
import '../../components.dart';

class PromptTile extends StatelessWidget {
  const PromptTile({
    this.decoration,
    this.onTap,
    this.onDeleted,
    this.onDuplicated,
    this.onAddedToProject,
    this.onRemovedFromProject,
    this.showProjectName = true,
    required this.prompt,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final void Function(int newPromptId)? onDuplicated;
  final void Function()? onRemovedFromProject;
  final void Function(int projectId)? onAddedToProject;
  final Decoration? decoration;
  final bool showProjectName;
  final Prompt prompt;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Prompt>.value(value: prompt),
        Provider<bool>.value(value: showProjectName),
        FutureProvider<String?>(
          initialData: null,
          create: (context) =>
              prompt.getContent(context.db, characterLimit: 1000),
        ),
        ChangeNotifierProvider<ShadContextMenuController>(
          create: (_) => ShadContextMenuController(),
        ),
      ],
      builder: (context, child) => _PromptContextMenu(
        showProjectName: showProjectName,
        controller: context.read(),
        onDeleted: onDeleted,
        onDuplicated: onDuplicated,
        onRemovedFromProject:
            prompt.projectId != null ? onRemovedFromProject : null,
        onAddedToProject: onAddedToProject,
        child: child!,
      ),
      child: HoverTapBuilder(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        onClicked: onTap,
        builder: (_, isHovering) => AnimatedContainer(
          duration: Effects.shortDuration,
          curve: Effects.snappyOutCurve,
          decoration: ShapeDecoration(
            shape: Superellipse.border12,
            color: context.brightSurface,
            shadows: isHovering
                ? [
                    ...mediumShadows(),
                    ...broadShadows(context, elevation: 5.0),
                  ]
                : focusedShadows(elevation: 0.5),
          ),
          padding: k12APadding,
          child: const Column(
            children: [
              _PromptTileTitle(),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Padding(
                      padding: k4HPadding,
                      child: _PromptTileContent(),
                    ),
                    _PromptUrl(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromptTileTitle extends StatelessWidget {
  const _PromptTileTitle();

  @override
  Widget build(BuildContext context) {
    final prompt = context.watch<Prompt>();
    final textTheme = context.textTheme;
    final textGray = PColors.textGray.resolveFrom(context);
    final isTitled = prompt.title.let((t) => t.isNotEmpty);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(4.0),
        Expanded(
          child: Text(
            isTitled ? prompt.title : 'Untitled',
            style: textTheme.large.copyWith(color: isTitled ? null : textGray),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Gap(4.0),
        CButton(
          tooltip: 'More',
          onTap: () {
            context.read<ShadContextMenuController>().toggle();
          },
          padding: k4APadding,
          child: const ShadImage.square(
            LucideIcons.ellipsis,
            size: 16.0,
          ),
        ),
      ],
    );
  }
}

class _PromptTileContent extends StatelessWidget {
  const _PromptTileContent();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final showProjectName = context.watch<bool>();
    final prompt = context.watch<Prompt>();
    final hasNotes = prompt.notes.let((d) => d.isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasNotes)
          Text(
            prompt.notes,
            style: textTheme.muted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        Text(
          timeAgo(prompt.createdAt),
          style: textTheme.muted,
        ),
        if (prompt.projectId != null && showProjectName)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: ProjectName(prompt.projectId!),
          ),
        const Divider(),
        Expanded(
          child: Builder(
            builder: (context) {
              final string = context.watch<String?>();
              if (string == null) {
                return const SizedBox();
              }
              return Padding(
                padding: k4APadding,
                child: ShaderMask(
                  shaderCallback: (bounds) => SmoothGradient(
                    from: Colors.transparent,
                    to: Colors.white,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcATop,
                  child: Text(
                    string,
                    style: textTheme.p.apply(fontSizeFactor: .5),
                    overflow: TextOverflow.fade,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PromptUrl extends StatelessWidget {
  const _PromptUrl();

  @override
  Widget build(BuildContext context) {
    final prompt = context.watch<Prompt>();
    if (prompt.chatUrl?.isEmpty ?? true) return const SizedBox();
    final linkColor = CupertinoColors.link.resolveFrom(context);
    return ShadButton.secondary(
      shadows: focusedShadows(elevation: 0.1),
      onPressed: () => launchUrlString(prompt.chatUrl!),
      icon: const ShadImage.square(
        LucideIcons.arrowUpRight,
        size: 16.0,
      ),
      hoverBackgroundColor: context.theme.resolveColor(
        linkColor.tint(.95),
        linkColor.shade(.8),
      ),
      child: const Text('Chat'),
    );
  }
}

class _PromptContextMenu extends StatelessWidget {
  const _PromptContextMenu({
    required this.showProjectName,
    required this.controller,
    required this.onDeleted,
    required this.onDuplicated,
    required this.onRemovedFromProject,
    required this.onAddedToProject,
    required this.child,
  });

  final bool showProjectName;
  final ShadContextMenuController controller;
  final VoidCallback? onDeleted;
  final void Function(int newPromptId)? onDuplicated;
  final void Function()? onRemovedFromProject;
  final void Function(int projectId)? onAddedToProject;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShadContextMenuRegion(
      controller: controller,
      constraints: const BoxConstraints(minWidth: 200.0, maxWidth: 300.0),
      items: [
        ShadContextMenuItem(
          onPressed: () async {
            final toaster = context.toaster;
            try {
              final content = await context.prompt.getContent(context.db);
              await Clipboard.setData(ClipboardData(text: content));
              toaster.show(
                const ShadToast(
                  title: Text('Prompt Copied!'),
                  description: Text('Prompt content copied to clipboard.'),
                ),
              );
            } catch (e, s) {
              debugPrint('Error getting prompt content: $e. Stack: $s');
              toaster.show(
                ShadToast.destructive(
                  title: const Text('Error Copying Prompt'),
                  description:
                      Text('Failed to copy prompt content to clipboard. $e'),
                ),
              );
            }
          },
          trailing: const ShadImage.square(
            LucideIcons.copy,
            size: 16.0,
          ),
          child: const Text('Copy Prompt'),
        ),
        ShadContextMenuItem(
          onPressed: () async {
            await exportPrompt(
              context,
              context.db,
              context.prompt.id,
            );
          },
          trailing: const ShadImage.square(
            LucideIcons.share,
            size: 16.0,
          ),
          child: const Text('Export…'),
        ),
        if (onDuplicated != null)
          ShadContextMenuItem(
            onPressed: () async {
              final toaster = context.toaster;
              try {
                final newPromptId = await context.db.duplicatePrompt(
                  context.prompt.id,
                );
                onDuplicated?.call(newPromptId);
              } catch (e, s) {
                debugPrint('Error duplicating prompt: $e. Stack: $s');
                toaster.show(
                  ShadToast.destructive(
                    title: const Text('Error Duplicating Prompt'),
                    description: Text('Failed to duplicate prompt. $e'),
                  ),
                );
              }
            },
            trailing: const ShadImage.square(
              LucideIcons.copyPlus,
              size: 16.0,
            ),
            child: const Text('Duplicate'),
          ),
        const Divider(height: 8.0),
        if (context.watch<Prompt>().projectId != null) ...[
          if (showProjectName)
            ShadContextMenuItem(
              onPressed: () async {
                context.pushProjectRoute(id: context.prompt.projectId!);
              },
              trailing: const ShadImage.square(
                LucideIcons.folderSearch,
                size: 16.0,
              ),
              child: const Text('Go to Project'),
            ),
          if (onRemovedFromProject != null)
            ShadContextMenuItem(
              onPressed: () async {
                final toaster = context.toaster;
                try {
                  final prompt = context.prompt;
                  if (prompt.projectId == null) return;
                  await context.db.removePromptFromProject(prompt.id);
                  onRemovedFromProject?.call();
                } catch (e, s) {
                  debugPrint(
                    'Error removing prompt from project: $e. Stack: $s',
                  );
                  toaster.show(
                    ShadToast.destructive(
                      title: const Text('Error Removing Prompt from Project'),
                      description: Text('$e'),
                    ),
                  );
                }
              },
              trailing: const ShadImage.square(
                LucideIcons.folderMinus,
                size: 16.0,
              ),
              child: const Text('Remove from Project'),
            ),
        ],
        if (onAddedToProject != null)
          ShadContextMenuItem(
            onPressed: () async {
              final toaster = context.toaster;
              try {
                final prompt = context.prompt;
                final db = context.db;
                final project = await pickProject(
                  context,
                  currentProject: prompt.projectId,
                );
                if (project == null) return;
                if (!project.present) {
                  await db.removePromptFromProject(prompt.id);
                  onRemovedFromProject?.call();
                } else {
                  final projectId = project.value.id;
                  await db.addPromptToProject(projectId, prompt.id);
                  onAddedToProject?.call(projectId);
                }
              } catch (e, s) {
                debugPrint(
                  'Error adding prompt to project: $e. Stack: $s',
                );
                toaster.show(
                  ShadToast.destructive(
                    title: const Text('Error Adding Prompt to Project'),
                    description: Text('$e'),
                  ),
                );
              }
            },
            trailing: const ShadImage.square(
              LucideIcons.folderInput,
              size: 16.0,
            ),
            child: const Text('Move to Project…'),
          ),
        if (onDeleted != null) ...[
          const Divider(height: 8.0),
          ShadContextMenuItem(
            onPressed: () {
              context.db.deletePrompt(context.prompt.id);
              onDeleted?.call();
            },
            trailing: const ShadImage.square(
              LucideIcons.trash,
              size: 16.0,
            ),
            child: const Text('Delete Prompt'),
          ),
        ],
      ],
      child: child,
    );
  }
}

extension _PromptTileExtension on BuildContext {
  Prompt get prompt => read<Prompt>();
}
