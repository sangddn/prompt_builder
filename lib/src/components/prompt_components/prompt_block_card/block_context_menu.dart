part of 'prompt_block_card.dart';

class _BlockContextMenu extends StatelessWidget {
  const _BlockContextMenu({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLocalFile = context.isLocalFile();
    return ShadContextMenuRegion(
      items: [
        _ContextMenuAction(
          HugeIcons.strokeRoundedEye,
          'Peek',
          () => peekBlock(context, context.block),
        ),
        if (isLocalFile) ...[
          _ContextMenuAction(
            HugeIcons.strokeRoundedAppleFinder,
            'Reveal in Finder',
            () => revealInFinder(context.block.filePath!),
          ),
          const Divider(height: 8),
          CopyButton.builder(
            data: context.block.copyData,
            builder: (_, __, copy) => _ContextMenuAction(
              HugeIcons.strokeRoundedFileAttachment,
              'Copy Raw Data',
              copy,
            ),
          ),
        ],
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.copyToPrompt() == null)) {
              return const SizedBox.shrink();
            }
            return CopyButton.builder(
              data: () => context.block.copyToPrompt(),
              builder: (_, __, copy) => _ContextMenuAction(
                HugeIcons.strokeRoundedCopy01,
                'Copy Text',
                copy,
              ),
            );
          },
        ),
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.url == null)) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const Divider(height: 8),
                CopyButton.builder(
                  data: () => context.block.url!,
                  builder: (_, __, copy) => _ContextMenuAction(
                    LucideIcons.link,
                    'Copy URL',
                    copy,
                  ),
                ),
                _ContextMenuAction(
                  LucideIcons.arrowUpRight,
                  'Open URL',
                  () => launchUrlString(context.block.url!),
                ),
              ],
            );
          },
        ),
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.transcript == null)) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const Divider(height: 8),
                CopyButton.builder(
                  data: () => context.block.transcript!,
                  builder: (_, __, copy) => _ContextMenuAction(
                    LucideIcons.fileAudio2,
                    'Copy Transcript',
                    copy,
                  ),
                ),
                _ContextMenuAction(
                  LucideIcons.save,
                  'Save Transcript as File',
                  () => _saveTranscriptAsMarkdown(context, context.block),
                ),
                _ContextMenuAction(
                  LucideIcons.delete,
                  'Remove Transcript',
                  () => context.db
                      .removeFields(context.block.id, transcript: true),
                ),
              ],
            );
          },
        ),
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.caption == null)) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const Divider(height: 8),
                CopyButton.builder(
                  data: () => context.block.caption!,
                  builder: (_, __, copy) => _ContextMenuAction(
                    LucideIcons.fileImage,
                    'Copy Description',
                    copy,
                  ),
                ),
                _ContextMenuAction(
                  LucideIcons.save,
                  'Save Description as File',
                  () => _saveDescriptionAsMarkdown(context, context.block),
                ),
                _ContextMenuAction(
                  LucideIcons.delete,
                  'Remove Description',
                  () =>
                      context.db.removeFields(context.block.id, caption: true),
                ),
              ],
            );
          },
        ),
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.summary == null)) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const Divider(height: 8),
                CopyButton.builder(
                  data: () => context.block.summary!,
                  builder: (_, __, copy) => _ContextMenuAction(
                    LucideIcons.fileText,
                    'Copy Summary',
                    copy,
                  ),
                ),
                _ContextMenuAction(
                  LucideIcons.save,
                  'Save Summary as File',
                  () => _saveSummaryAsMarkdown(context, context.block),
                ),
                _ContextMenuAction(
                  LucideIcons.delete,
                  'Remove Summary',
                  () => context.db.removeFields(
                    context.block.id,
                    summary: true,
                    summaryTokenCount: true,
                    summaryTokenCountMethod: true,
                  ),
                ),
              ],
            );
          },
        ),
        if (context.selectBlock(
          (b) => b.fullContentTokenCount != null || b.summaryTokenCount != null,
        )) ...[
          const Divider(height: 8),
          _ContextMenuAction(
            LucideIcons.refreshCcw,
            'Re-estimate Token Count',
            () => context.db.removeFields(
              context.block.id,
              fullContentTokenCount: true,
              summaryTokenCount: true,
              fullContentTokenCountMethod: true,
              summaryTokenCountMethod: true,
            ),
          ),
        ],
      ],
      child: child,
    );
  }
}

class _ContextMenuAction extends StatelessWidget {
  const _ContextMenuAction(this.icon, this.label, this.onTap);

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ShadContextMenuItem(
        onPressed: onTap,
        trailing: Icon(icon, size: 16.0),
        child: Text(label),
      );
}
