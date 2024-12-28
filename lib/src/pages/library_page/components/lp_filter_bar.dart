part of '../library_page.dart';

class _LPFilterBar extends StatelessWidget {
  const _LPFilterBar();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Row(
        children: [
          Gap(24.0),
          Text('Filter'),
        ],
      ),
    );
  }
}
