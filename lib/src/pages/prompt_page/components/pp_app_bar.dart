part of '../prompt_page.dart';

class _PPAppBar extends StatelessWidget {
  const _PPAppBar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56.0,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Center(child: _PromptTitle()),
          MaybeBackButton(),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _ExportButton(),
          ),
        ],
      ),
    );
  }
}

class _PromptTitle extends StatelessWidget {
  const _PromptTitle();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.muted;
    final title = context.selectPrompt((p) => p?.title);
    if (title == null) {
      return GrayShimmer(
        child: Text('Loading…', style: style),
      );
    }

    final id = context.selectPrompt((p) => p?.id);
    final db = context.db;

    void updatePromptTitle(String newTitle) {
      if (id != null && newTitle.trim() != title) {
        db.updatePrompt(id, title: newTitle);
      }
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400.0),
      child: ValueProvider<TextEditingController>(
        create: (_) => TextEditingController(text: title),
        onDisposed: (context, controller) {
          final text = controller?.text.trim();
          if (text == null || text.isEmpty) return;
          updatePromptTitle(text);
        },
        builder: (context, child) {
          return TextField(
            controller: context.read(),
            decoration: InputDecoration.collapsed(
              hintText: 'Untitled',
              hintStyle:
                  style.copyWith(color: PColors.darkGray.resolveFrom(context)),
            ),
            style: style,
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: k8APadding,
        child: CButton(
          tooltip: 'Export',
          cornerRadius: 12.0,
          onTap: () async {
            final promptId = context.prompt?.id;
            if (promptId == null) return;
            final db = context.db;
            await exportPrompt(context, db, promptId);
          },
          child: const Icon(LucideIcons.share, size: 16.0),
        ),
      ),
    );
  }
}
