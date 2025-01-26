import 'package:flutter/cupertino.dart';
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
    required this.db,
    required this.prompt,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                hasNoDescription ? 'No description' : prompt.notes,
                style: textTheme.p
                    .copyWith(color: hasNoDescription ? darkGray : null),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    required this.child,
  });

  final VoidCallback? onDeleted;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShadContextMenuRegion(
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
      child: child,
    );
  }
}
