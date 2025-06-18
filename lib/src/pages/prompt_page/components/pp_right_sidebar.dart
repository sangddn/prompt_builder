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
          Gap(4.0),
          _PromptChatUrl(),
          Gap(12.0),
          _PromptNotes(),
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

class _PromptChatUrl extends StatelessWidget {
  const _PromptChatUrl();

  @override
  Widget build(BuildContext context) {
    var url = context.selectPrompt((p) => p == null ? null : (p.chatUrl ?? ''));
    if (url == null) return const SizedBox.shrink();
    url = url.isEmpty ? null : url;
    final db = context.db;
    final id = context.selectPrompt((p) => p?.id);
    return ValueProvider<TextEditingController>(
      create: (_) => TextEditingController(text: url),
      onDisposed: (context, controller) {
        final text = controller?.text.trim();
        if (text == null || id == null) return;
        db.updatePrompt(id, chatUrl: text);
      },
      builder: (context, child) {
        return const Material(
          shape: Superellipse.border8,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: 36.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Expanded(child: _UrlField()), _GoToChat()],
            ),
          ),
        );
      },
    );
  }
}

class _UrlField extends StatelessWidget {
  const _UrlField();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.muted;
    final url = context.selectPrompt((p) => p?.chatUrl);
    final controller = context.read<TextEditingController>();
    return ColoredBox(
      color: PColors.lightGray.resolveFrom(context),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Chat URL',
            hintStyle: style,
            border: InputBorder.none,
            isCollapsed: true,
            contentPadding: k16H8VPadding,
          ),
          textAlign: TextAlign.center,
          style: style,
          onTap: () async {
            if (url == null && controller.text.isEmpty) {
              final uri = await Clipboard.getData(
                'text/plain',
              ).then((r) => _getUri(r?.text));
              if (uri != null) controller.text = uri.toString();
            }
          },
        ),
      ),
    );
  }
}

Uri? _getUri(String? text) {
  if (text == null || text.isEmpty) return null;
  final uri = Uri.tryParse(text);
  if (uri?.scheme != 'http' && uri?.scheme != 'https') {
    return null;
  }
  return uri;
}

class _GoToChat extends AnimatedStatelessWidget {
  const _GoToChat();

  @override
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.sizeFade(
        child,
        axis: Axis.horizontal,
        layoutBuilder: alignedLayoutBuilder(AlignmentDirectional.centerStart),
      );

  @override
  Widget buildChild(BuildContext context) {
    final url = context.watch<TextEditingController>().text.trim();
    final uri = _getUri(url);
    if (uri == null) return const SizedBox.shrink();
    final lightGray = PColors.lightGray.resolveFrom(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VerticalDivider(
          width: 1.0,
          thickness: 1.0,
          color: lightGray.withOpacityFactor(.5),
        ),
        ColoredBox(
          color: lightGray,
          child: CButton(
            tooltip: null,
            onTap: () => launchUrlString(uri.toString()),
            cornerRadius: 12.0,
            padding: k12HPadding,
            color: Colors.transparent,
            child: Icon(
              LucideIcons.link,
              size: 12.0,
              color: PColors.textGray.resolveFrom(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromptNotes extends StatelessWidget {
  const _PromptNotes();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.p;
    final notes = context.selectPrompt((p) => p?.notes);
    if (notes == null) {
      return GrayShimmer(child: Text('Loading…', style: style));
    }
    final id = context.selectPrompt((p) => p?.id);
    final db = context.db;

    void updatePromptNotes(String newNotes) {
      if (id != null && newNotes != notes) {
        db.updatePrompt(id, notes: newNotes);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Notes', style: context.textTheme.muted),
        const Gap(4.0),
        ValueProvider<TextEditingController>(
          create: (_) => TextEditingController(text: notes),
          onDisposed: (context, controller) {
            final text = controller?.text.trim();
            if (text == null) return;
            updatePromptNotes(text);
          },
          builder:
              (context, child) => TextField(
                controller: context.read(),
                decoration: InputDecoration(
                  hintText: 'Aa',
                  hintStyle: style.copyWith(
                    color: PColors.textGray.resolveFrom(context),
                  ),
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
        Text('Tags', style: context.textTheme.muted),
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
                          onTap: () => removeTag(tag),
                          padding:
                              k4APadding + const EdgeInsets.only(right: 4.0),
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
          builder:
              (context, _) => Padding(
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
