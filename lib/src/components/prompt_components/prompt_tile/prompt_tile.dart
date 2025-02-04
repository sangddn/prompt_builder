import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../app.dart';
import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../../router/router.gr.dart';
import '../../components.dart';

class PromptTile extends StatelessWidget {
  const PromptTile({
    this.decoration,
    this.onTap,
    this.onDeleted,
    this.onDuplicated,
    this.onRemovedFromProject,
    required this.prompt,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final void Function(int newPromptId)? onDuplicated;
  final void Function(int promptId)? onRemovedFromProject;
  final Decoration? decoration;
  final Prompt prompt;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Prompt>.value(value: prompt),
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
        controller: context.read(),
        onDeleted: onDeleted,
        onDuplicated: onDuplicated,
        onRemovedFromProject:
            prompt.projectId != null ? onRemovedFromProject : null,
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
          padding: k16H12VPadding,
          child: _PromptTileContent(prompt),
        ),
      ),
    );
  }
}

class _PromptTileContent extends StatelessWidget {
  const _PromptTileContent(this.prompt);

  final Prompt prompt;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final isTitled = prompt.title.let((t) => t.isNotEmpty);
    final hasNotes = prompt.notes.let((d) => d.isNotEmpty);
    final textGray = PColors.textGray.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                isTitled ? prompt.title : 'Untitled',
                style:
                    textTheme.large.copyWith(color: isTitled ? null : textGray),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
        ),
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
        const Divider(),
        Expanded(
          child: Builder(
            builder: (context) {
              final string = context.watch<String?>();
              if (string == null) {
                return const ContainerShimmer(
                  height: double.infinity,
                  radius: 4.0,
                );
              }
              return Padding(
                padding: k4APadding,
                child: Text(
                  string,
                  style: textTheme.p.apply(fontSizeFactor: .5),
                  overflow: TextOverflow.fade,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PromptContextMenu extends StatelessWidget {
  const _PromptContextMenu({
    required this.controller,
    required this.onDeleted,
    required this.onDuplicated,
    required this.onRemovedFromProject,
    required this.child,
  });

  final ShadContextMenuController controller;
  final VoidCallback? onDeleted;
  final void Function(int newPromptId)? onDuplicated;
  final void Function(int promptId)? onRemovedFromProject;
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
        if (context.watch<Prompt>().projectId != null) ...[
          const Divider(height: 8.0),
          ShadContextMenuItem(
            onPressed: () async {
              context.pushRoute(ProjectRoute(id: context.prompt.projectId!));
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
                  onRemovedFromProject?.call(prompt.id);
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
