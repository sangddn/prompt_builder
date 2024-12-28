part of '../prompt_page.dart';

class _PPPromptContent extends StatelessWidget {
  const _PPPromptContent();

  @override
  Widget build(BuildContext context) {
    final isEditing =
        context.watch<ValueNotifier<_PromptContentViewState>>().value ==
            _PromptContentViewState.edit;
    final theme = context.theme;
    final color = theme.colorScheme.background;
    final resolvedColor = theme.resolveColor(color.shade(.1), color.tint(.035));
    return Container(
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow:
            mediumShadows(elevation: .75, offsetDelta: const Offset(0.0, -.25)),
      ),
      margin: k8HPadding + const EdgeInsets.only(top: 4.0),
      height: double.infinity,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Visibility.maintain(
            visible: isEditing,
            child: const _PromptContentEditMode(),
          ),
          Visibility(
            visible: !isEditing,
            maintainState: true,
            child: const _PromptContentPreviewMode(),
          ),
        ],
      ),
    );
  }
}

class _PromptContentEditMode extends StatelessWidget {
  const _PromptContentEditMode();

  @override
  Widget build(BuildContext context) {
    final blocks = context.watchBlockKeys();
    final widgets = blocks
        .indexedExpand(
          (i, e) => [
            Padding(
              padding: k16H8VPadding,
              child: Builder(
                key: e.$2,
                builder: (context) => BlockRouterWidget(
                  database: context.db,
                  block: context.watchBlock(e.$1)!,
                ),
              ),
            ),
            if (i < blocks.length - 1) const Divider(thickness: .75),
          ],
        )
        .toList();

    return CustomScrollView(
      slivers: [
        const SliverGap(24.0),
        SliverPadding(
          padding: k16HPadding,
          sliver: SuperSliverList.list(children: widgets),
        ),
        const SliverGap(64.0),
      ],
    );
  }
}

class _PromptContentPreviewMode extends StatelessWidget {
  const _PromptContentPreviewMode();

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(64.0),
        children: [SelectableText(context.getContent(listen: true))],
      );
}
