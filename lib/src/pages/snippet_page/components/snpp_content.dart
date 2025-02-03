part of '../snippet_page.dart';

class _SNPPContent extends StatelessWidget {
  const _SNPPContent();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final color = theme.colorScheme.background;
    final resolvedColor =
        theme.resolveColor(color.shade(.01), color.tint(.035));
    final style = context.textTheme.p;
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
      margin: k8HPadding + const EdgeInsets.only(top: 4.0, left: 64.0),
      padding: k32APadding,
      height: double.infinity,
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SnippetTitle(),
          const Gap(16.0),
          Expanded(
            child: TextField(
              controller: context.read<_ContentController?>(),
              maxLines: null,
              decoration: InputDecoration.collapsed(
                hintText: 'Aa',
                hintStyle: style.copyWith(
                  color: PColors.darkGray.resolveFrom(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnippetTitle extends StatelessWidget {
  const _SnippetTitle();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.h3;
    final snippet = context.watchSnippet();
    if (snippet == null) {
      return GrayShimmer(
        child: Text('Loading…', style: style),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400.0),
      child: TextField(
        controller: context.read<_TitleController>(),
        decoration: InputDecoration.collapsed(
          hintText: 'Untitled',
          hintStyle:
              style.copyWith(color: PColors.darkGray.resolveFrom(context)),
        ),
        style: style,
      ),
    );
  }
}
