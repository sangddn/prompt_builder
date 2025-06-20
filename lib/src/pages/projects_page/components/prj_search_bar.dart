part of '../projects_page.dart';

class _PRJSearchBar extends StatelessWidget {
  const _PRJSearchBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ShadInput(
        controller: context.read<ProjectQueryNotifier>(),
        placeholder: const Text('Search projects...'),
        leading: const Padding(
          padding: k4APadding,
          child: Icon(LucideIcons.search, size: 16.0),
        ),
      ),
    );
  }
}
