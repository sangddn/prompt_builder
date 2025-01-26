import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../components.dart';

class PromptTile extends StatelessWidget {
  const PromptTile({
    this.onTap,
    this.onDeleted,
    this.onDuplicated,
    required this.db,
    required this.prompt,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final void Function(int newPromptId)? onDuplicated;
  final Database db;
  final Prompt prompt;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Database>.value(value: db),
        Provider<Prompt>.value(value: prompt),
      ],
      child: _PromptContextMenu(
        onDeleted: onDeleted,
        onDuplicated: onDuplicated,
        child: CButton(
          tooltip: 'Open Prompt',
          onTap: onTap,
          padding: k16H12VPadding,
          cornerRadius: 16.0,
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
    final isUntitled = prompt.title.let((t) => t.isEmpty);
    final hasNoDescription = prompt.notes.let((d) => d.isEmpty);
    final textGray = PColors.textGray.resolveFrom(context);
    final darkGray = PColors.darkGray.resolveFrom(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUntitled ? 'Untitled' : prompt.title,
                style: textTheme.large
                    .copyWith(color: isUntitled ? textGray : null),
              ),
              Text(
                hasNoDescription ? 'No description' : prompt.notes,
                style: textTheme.p
                    .copyWith(color: hasNoDescription ? darkGray : null),
              ),
            ],
          ),
        ),
        const CupertinoListTileChevron(),
      ],
    );
  }
}

class _PromptContextMenu extends StatelessWidget {
  const _PromptContextMenu({
    required this.onDeleted,
    required this.onDuplicated,
    required this.child,
  });

  final VoidCallback? onDeleted;
  final void Function(int newPromptId)? onDuplicated;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShadContextMenuRegion(
      constraints: const BoxConstraints(minWidth: 200.0, maxWidth: 300.0),
      items: [
        ShadContextMenuItem(
          onPressed: () async {
            final toaster = context.toaster;
            try {
              final content = await context
                  .read<Prompt>()
                  .getContent(context.read<Database>());
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
        if (onDuplicated != null)
          ShadContextMenuItem(
            onPressed: () async {
              final toaster = context.toaster;
              try {
                final newPromptId = await context
                    .read<Database>()
                    .duplicatePrompt(context.read<Prompt>().id);
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
        if (onDeleted != null) ...[
          const Divider(height: 8.0),
          ShadContextMenuItem(
            onPressed: () {
              context.read<Database>().deletePrompt(context.read<Prompt>().id);
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
