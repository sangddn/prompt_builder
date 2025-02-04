part of '../library_page.dart';

class _LPFilterBar extends StatelessWidget {
  const _LPFilterBar();

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: TagFilterBar(
          type: TagType.prompt,
          notifier: context.read(),
        ),
      );
}
