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

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400.0),
      child: ValueProvider<TextEditingController>(
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
            label: const Text('Description'),
            labelStyle: context.textTheme.muted,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle:
                style.copyWith(color: PColors.textGray.resolveFrom(context)),
            border: InputBorder.none,
          ),
          minLines: 3,
          maxLines: 15,
          style: style,
        ),
      ),
    );
  }
}
