part of '../resources_page.dart';

class _RPSnippetList extends StatelessWidget {
  const _RPSnippetList();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.isLoading();
    final count = context.selectResources((r) => r?.keys.length ?? 1);
    return SuperSliverList.builder(
      listController: context.read(),
      itemCount: count,
      itemBuilder: (context, index) {
        if (isLoading) {
          return const SizedBox(
            height: 40.0,
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return Builder(
          builder: (context) {
            final (tag, snippets) = context.selectResources(
              (r) {
                final key = r?.keys.toList().elementAtOrNull(index);
                if (key == null) return (null, null);
                final snippets = r?[key] ?? const IList.empty();
                return (key, snippets);
              },
            );
            if (tag == null) return const SizedBox.shrink();
            return _TagSection(
              index: index,
              tag: tag,
              snippets: snippets!,
            );
          },
        );
      },
    );
  }
}

class _TagSection extends StatefulWidget {
  const _TagSection({
    required this.tag,
    required this.snippets,
    required this.index,
  });

  final String tag;
  final IList<SnippetResource> snippets;
  final int index;

  @override
  State<_TagSection> createState() => _TagSectionState();
}

class _TagSectionState extends State<_TagSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(24.0),
        Text(widget.tag, style: context.textTheme.h3),
        const Gap(16.0),
        MasonryGridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.snippets.length,
          itemBuilder: (context, index) =>
              _ResourceCard(widget.snippets[index]),
        ),
        const Gap(12.0),
      ],
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard(this.resource);

  final SnippetResource resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: Superellipse.border24,
        color: PColors.lightGray.resolveFrom(context),
      ),
      padding: k12APadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: ShapeDecoration(
                shape: Superellipse.border12,
                color: context.colorScheme.card,
                shadows: focusedShadows(elevation: .25),
              ),
              padding: k16APadding,
              child: SingleChildScrollView(
                child: Text(
                  resource.content,
                  style: context.textTheme.muted,
                ),
              ),
            ),
          ),
          const Gap(12.0),
          Padding(
            padding: k4HPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                PTooltip(
                  message: resource.title,
                  child: Text(
                    resource.title,
                    style: context.textTheme.list,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Gap(8.0),
                GestureDetector(
                  onTap:
                      resource.authorUrl?.let((u) => () => launchUrlString(u)),
                  child: Text(
                    resource.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          const Gap(12.0),
          _Actions(resource),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions(this.snippet);

  final SnippetResource snippet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ShadButton.secondary(
            onPressed: () => context.saveResource(snippet),
            icon: const ShadImage.square(
              HugeIcons.strokeRoundedQuoteDown,
              size: 16.0,
            ),
            child: const Text('Save'),
          ),
        ),
        const Gap(8.0),
        Expanded(
          child: CopyButton.builder(
            data: () => snippet.content,
            builder: (context, _, copy) => ShadButton.secondary(
              onPressed: copy,
              icon: const ShadImage.square(
                HugeIcons.strokeRoundedCopy01,
                size: 16.0,
              ),
              child: const Text('Copy'),
            ),
          ),
        ),
      ],
    );
  }
}
