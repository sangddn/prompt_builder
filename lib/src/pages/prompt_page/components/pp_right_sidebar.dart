part of '../prompt_page.dart';

class _PPRightSidebar extends StatelessWidget {
  const _PPRightSidebar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 4.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(12.0),
          _PromptDescription(),
          Gap(8.0),
          _PromptTags(),
          Spacer(),
          _PPUnsupportedBlockSection(),
          Gap(16.0),
          _PPCopySection(),
          Gap(16.0),
        ],
      ),
    );
  }
}

class _PromptDescription extends StatelessWidget {
  const _PromptDescription();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.p;
    final description = context.selectPrompt((p) => p?.notes);
    if (description == null) {
      return GrayShimmer(
        child: Text('Loading…', style: style),
      );
    }
    final id = context.selectPrompt((p) => p?.id);
    final db = context.db;

    void updatePromptDescription(String newDescription) {
      if (id != null && newDescription != description) {
        db.updatePrompt(id, notes: newDescription);
        PromptTitleOrDescriptionChangedNotification(id: id).dispatch(context);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Description', style: context.textTheme.muted),
        const Gap(4.0),
        ValueProvider<TextEditingController>(
          create: (_) => TextEditingController(text: description),
          onDisposed: (context, controller) {
            final text = controller?.text.trim();
            if (text == null || text.isEmpty) return;
            updatePromptDescription(text);
          },
          builder: (context, child) => TextField(
            controller: context.read(),
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
        ),
      ],
    );
  }
}

class _PromptTags extends StatelessWidget {
  const _PromptTags();

  @override
  Widget build(BuildContext context) {
    final (id, tags) = context.selectPrompt((p) => (p?.id, IList(p?.tagsList)));
    if (id == null) return const SizedBox.shrink();
    final db = context.db;

    void addTag(String tag) {
      final newTags = [...tags, tag];
      db.updatePrompt(id, tags: newTags);
    }

    void removeTag(String tag) {
      final newTags = [...tags]..remove(tag);
      db.updatePrompt(id, tags: newTags);
    }

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
                    Text(tag),
                    CButton(
                      tooltip: 'Remove tag',
                      onTap: () => removeTag(tag),
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
              onEditingComplete: () {},
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  addTag(value);
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
