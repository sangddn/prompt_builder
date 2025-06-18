import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../app.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../router/router.dart';
import '../components.dart';

class SnippetTile extends StatelessWidget {
  const SnippetTile({
    this.showProjectName = true,
    this.isCollapsed = false,
    this.onDelete,
    this.onProjectChanged,
    this.onExpanded,
    required this.snippet,
    super.key,
  });

  final bool isCollapsed;
  final bool showProjectName;
  final VoidCallback? onDelete;
  final VoidCallback? onExpanded;
  final ValueChanged<Project?>? onProjectChanged;
  final Snippet snippet;

  @override
  Widget build(BuildContext context) {
    return StateProvider<IMap<String, String>>(
      createInitialValue: (_) => IMap(snippet.variables),
      child: MultiProvider(
        providers: [
          Provider<Snippet>.value(value: snippet),
          Provider<VoidCallback?>.value(value: onExpanded),
          Provider<bool>.value(value: showProjectName),
          if (!isCollapsed) ...[
            ValueProvider<TextEditingController>(
              create: (_) => TextEditingController(text: snippet.content),
              onNotified: (context, controller) {
                context.db.updateSnippet(
                  context.snippet.id,
                  content: controller?.text ?? '',
                );
                context.variablesNotifier.value = IMap(
                  SnippetExtension.parseVariables(controller?.text ?? ''),
                );
              },
            ),
            ListenableProvider(create: (_) => FocusNode()),
          ],
        ],
        child: ShadContextMenuRegion(
          constraints: const BoxConstraints(minWidth: 200.0, maxWidth: 300.0),
          items: [
            if (snippet.projectId case final projectId?) ...[
              if (showProjectName)
                ShadContextMenuItem(
                  onPressed: () async {
                    context.pushProjectRoute(id: projectId);
                  },
                  trailing: const Icon(LucideIcons.folderSearch, size: 16.0),
                  child: const Text('Go to Project'),
                ),
              ShadContextMenuItem(
                onPressed: () async {
                  await context.db.removeSnippetFromProject(snippet.id);
                  onProjectChanged?.call(null);
                },
                trailing: const Icon(LucideIcons.folderMinus, size: 16),
                child: const Text('Remove from Project'),
              ),
            ],
            ShadContextMenuItem(
              onPressed: () async {
                final db = context.db;
                final project = await pickProject(
                  context,
                  currentProject: snippet.projectId,
                );
                if (project == null) return;
                if (!project.present) {
                  await db.removeSnippetFromProject(snippet.id);
                  onProjectChanged?.call(null);
                } else {
                  final projectId = project.value.id;
                  await db.addSnippetToProject(projectId, snippet.id);
                  onProjectChanged?.call(project.value);
                }
              },
              trailing: const Icon(LucideIcons.folderInput, size: 16.0),
              child: const Text('Move to Project…'),
            ),
            const Divider(height: 8.0),
            ShadContextMenuItem(
              onPressed: () async {
                await context.db.deleteSnippet(snippet.id);
                onDelete?.call();
              },
              trailing: const Icon(LucideIcons.trash, size: 16),
              child: const Text('Delete'),
            ),
          ],
          child: Material(
            color: Colors.transparent,
            child: isCollapsed ? const _CollapsedContent() : const _Content(),
          ),
        ),
      ),
    );
  }
}

class _CollapsedContent extends StatelessWidget {
  const _CollapsedContent();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final snippet = context.snippet;
    return ListTile(
      leading: const Icon(LucideIcons.quote, size: 16.0),
      title: Text(
        snippet.title.isEmpty ? 'Untitled' : snippet.title,
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
            if (snippet.notes?.isNotEmpty ?? false) Text(snippet.notes!),
            Text(
              '${snippet.updatedAt != null && snippet.updatedAt != snippet.createdAt ? 'Updated ${timeAgo(snippet.updatedAt!).toLowerCase()} • ' : ''}Created ${timeAgo(snippet.createdAt).toLowerCase()}',
            ),
          ],
        ),
      ),
      trailing:
          snippet.projectId != null && context.watch<bool>()
              ? ProjectName(snippet.projectId!)
              : null,
      isThreeLine: snippet.notes?.isNotEmpty ?? false,
      visualDensity: VisualDensity.comfortable,
      shape: Superellipse.border16,
      tileColor: PColors.lightGray.resolveFrom(context),
      splashColor: Colors.transparent,
      onTap: context.watch<VoidCallback?>(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: k24H12VPadding,
      decoration: ShapeDecoration(
        shape: Superellipse.border12,
        color: PColors.lightGray.resolveFrom(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(child: _TitleField()),
              Gap(8.0),
              _ExpansionButton(),
            ],
          ),
          if (context.watch<bool>())
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
              child: ProjectName(context.snippet.projectId!),
            ),
          const Gap(6.0),
          const _ContentField(),
          const Gap(12.0),
          const _Variables(),
          const Gap(8.0),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    return ValueProvider<TextEditingController>(
      create: (_) => TextEditingController(text: context.snippet.title),
      onNotified: (context, controller) {
        context.db.updateSnippet(
          context.snippet.id,
          title: controller?.text ?? '',
        );
      },
      builder: (context, _) {
        final controller = context.read<TextEditingController>();
        if (context.snippet.title != controller.text) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.text = context.snippet.title;
          });
        }
        return TextField(
          controller: controller,
          decoration: InputDecoration.collapsed(
            hintText: 'Title',
            hintStyle: context.textTheme.muted,
          ),
          style: context.textTheme.muted,
        );
      },
    );
  }
}

class _ExpansionButton extends StatelessWidget {
  const _ExpansionButton();

  @override
  Widget build(BuildContext context) {
    return CButton(
      tooltip: 'Open',
      onTap: context.watch<VoidCallback?>(),
      padding: k8APadding,
      child: const Icon(LucideIcons.bookOpenText, size: 16.0),
    );
  }
}

class _ContentField extends StatelessWidget {
  const _ContentField();

  @override
  Widget build(BuildContext context) {
    final isFocused = context.isFocused();
    final controller = context.read<TextEditingController>();
    if (context.snippet.content != controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.text = context.snippet.content;
      });
    }
    return TextField(
      controller: controller,
      focusNode: context.read(),
      decoration: InputDecoration.collapsed(
        hintText: 'Content',
        hintStyle: context.textTheme.muted,
      ),
      style: context.textTheme.p,
      minLines: 2,
      maxLines: isFocused ? null : 3,
    );
  }
}

class _Variables extends AnimatedStatelessWidget {
  const _Variables();

  @override
  Widget buildChild(BuildContext context) {
    final variables = context.watch<IMap<String, String>>();
    final hasFocus = context.watch<FocusNode>().hasFocus;
    if (variables.isEmpty && !hasFocus) return const SizedBox.shrink();
    return SnippetVariables(variables: variables);
  }
}

extension _TileStateExtension on BuildContext {
  Snippet get snippet => read();
  ValueNotifier<IMap<String, String>> get variablesNotifier => read();
  bool isFocused() => watch<FocusNode>().hasFocus;
}
