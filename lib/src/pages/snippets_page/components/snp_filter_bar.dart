part of '../snippets_page.dart';

class _SNPFilterBar extends StatelessWidget {
  const _SNPFilterBar();

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: TagFilterBar(type: TagType.snippet, notifier: context.read()),
      );
}
