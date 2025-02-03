part of '../projects_page.dart';

class _PRJSearchBar extends StatelessWidget {
  const _PRJSearchBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ShadInput(
        controller: context.read<_SearchQueryNotifier>(),
        placeholder: const Text('Search projects...'),
        prefix: const Padding(
          padding: k4APadding,
          child: ShadImage.square(
            LucideIcons.search,
            size: 16.0,
          ),
        ),
      ),
    );
  }
}
