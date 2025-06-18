part of '../prompt_page.dart';

class _PPUnsupportedBlockSection extends StatelessWidget {
  const _PPUnsupportedBlockSection();

  @override
  Widget build(BuildContext context) {
    final unsupportedBlocks = context.selectBlocks(
      (bs) => bs.where((b) => b.type == BlockType.unsupported).toIList(),
    );
    if (unsupportedBlocks.isEmpty) return const SizedBox.shrink();
    final theme = context.theme;
    final textTheme = theme.textTheme;
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300.0),
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              PinnedHeaderSliver(
                child: ColoredBox(
                  color: theme.colorScheme.background,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(12.0),
                      Text('Unsupported files', style: context.textTheme.small),
                      const Gap(8.0),
                    ],
                  ),
                ),
              ),
              SuperSliverList.list(
                children: [
                  ...unsupportedBlocks.map((b) {
                    final filePath = b.filePath;
                    return CopyButton.builder(
                      data: b.copyToPromptOrData,
                      builder:
                          (context, _, copy) => ListTile(
                            dense: true,
                            onTap: copy,
                            shape: Superellipse.border8,
                            splashColor: Colors.transparent,
                            title: Text(
                              filePath?.let(path.basename) ?? b.displayName,
                              style: textTheme.list,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              filePath ?? b.url ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.muted,
                            ),
                            trailing: const Icon(
                              HugeIcons.strokeRoundedCopy01,
                              size: 16.0,
                            ),
                          ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 16.0, thickness: .5),
      ],
    );
  }
}
