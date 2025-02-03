part of '../snippet_page.dart';

class _SNPPRightSidebar extends StatelessWidget {
  const _SNPPRightSidebar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 4.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(12.0),
          _SnippetNotes(),
          Gap(8.0),
          _SnippetTags(),
          Spacer(),
          _Variables(),
          Divider(height: 32.0),
          Padding(
            padding: k8HPadding,
            child: _EstimatedTokenCount(),
          ),
          Gap(12.0),
          _ExactTokenCounter(),
          Gap(20.0),
          _CopySnippetButton(),
          Gap(16.0),
        ],
      ),
    );
  }
}

class _SnippetNotes extends StatelessWidget {
  const _SnippetNotes();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.p;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Notes', style: context.textTheme.muted),
        const Gap(4.0),
        TextField(
          controller: context.notesController,
          decoration: InputDecoration(
            hintText: 'Aa',
            hintStyle:
                style.copyWith(color: PColors.textGray.resolveFrom(context)),
            border: InputBorder.none,
          ),
          minLines: 3,
          maxLines: 15,
          style: style,
        ),
      ],
    );
  }
}

class _SnippetTags extends StatelessWidget {
  const _SnippetTags();

  @override
  Widget build(BuildContext context) {
    final tags = context.watchTags()?.value ?? const IList.empty();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Tags',
          style: context.textTheme.muted,
        ),
        if (tags.isNotEmpty) const Gap(4.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ...tags.map(
              (tag) => Container(
                padding: const EdgeInsets.only(left: 8.0),
                decoration: ShapeDecoration(
                  color: PColors.lightGray.resolveFrom(context),
                  shape: const SquircleStadiumBorder(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tag, style: context.textTheme.small.addWeight(-1)),
                    CButton(
                      tooltip: 'Remove tag',
                      onTap: () => context.removeTag(tag),
                      padding: k4APadding + const EdgeInsets.only(right: 4.0),
                      highlightColor: Colors.transparent,
                      child: Icon(
                        LucideIcons.x,
                        size: 14.0,
                        color: PColors.textGray.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: Effects.shortDuration,
                    curve: Effects.snappyOutCurve,
                  )
                  .scaleXY(
                    duration: Effects.shortDuration,
                    curve: Effects.snappyOutCurve,
                  ),
            ),
          ],
        ),
        const Gap(8.0),
        ValueProvider<TextEditingController>(
          create: (_) => TextEditingController(),
          builder: (context, _) => Padding(
            padding: k4HPadding,
            child: TextField(
              controller: context.read(),
              decoration: InputDecoration.collapsed(
                hintText: 'Enter to add',
                hintStyle: context.textTheme.muted,
              ),
              style: context.textTheme.p,
              onEditingComplete: () {},
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.addTag(value);
                  context.read<TextEditingController>().clear();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _Variables extends StatelessWidget {
  const _Variables();

  @override
  Widget build(BuildContext context) {
    return SnippetVariables(
      variables: context.watch<IMap<String, String>?>() ?? const IMap.empty(),
    );
  }
}

class _EstimatedTokenCount extends StatelessWidget {
  const _EstimatedTokenCount();

  @override
  Widget build(BuildContext context) {
    return EstimatedTokenCounter(
      watchContent: (context) => context.watchContent()?.text ?? '',
    );
  }
}

class _ExactTokenCounter extends StatelessWidget {
  const _ExactTokenCounter();

  @override
  Widget build(BuildContext context) {
    return ExactTokenCounter(
      hasContentChanged: (context, currentContent) =>
          context.select<_ContentController?, bool>(
        (c) => c?.text != currentContent,
      ),
      getContent: () => context.contentController?.text ?? '',
    );
  }
}

class _CopySnippetButton extends StatelessWidget {
  const _CopySnippetButton();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final copySpan = keyboardShortcutSpan(context, true, true, 'C');
    return CopyButton.builder(
      data: () => context.contentController?.text ?? '',
      builder: (context, show, copy) {
        return CButton(
          tooltip: copySpan,
          tooltipTriggerMode: TooltipTriggerMode.tap,
          padding: k16H8VPadding,
          color: theme.colorScheme.primary,
          onTap: copy,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadImage.square(
                HugeIcons.strokeRoundedCopy01,
                size: 14.0,
                color: theme.colorScheme.primaryForeground,
              ),
              const Gap(8.0),
              Flexible(
                child: Text(
                  'Copy Snippet',
                  style: theme.textTheme.p
                      .copyWith(color: theme.colorScheme.primaryForeground),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
