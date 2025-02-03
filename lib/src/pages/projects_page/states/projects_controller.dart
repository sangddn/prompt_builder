part of '../projects_page.dart';

const _kPageSize = 50;

final class _ProjectsController implements InfinityController<Project> {
  _ProjectsController({
    required this.db,
    required this.searchQueryNotifier,
    required this.sortByNotifier,
  });

  final Database db;
  final _SearchQueryNotifier searchQueryNotifier;
  final _SortByNotifier sortByNotifier;

  @override
  final pagingController = PagingController<int, Project>(firstPageKey: 0);

  @override
  void init() {
    pagingController.addPageRequestListener(_fetchPage);
    searchQueryNotifier.addListener(_refresh);
    sortByNotifier.addListener(_refresh);
  }

  @override
  void dispose() {
    pagingController.dispose();
    searchQueryNotifier.removeListener(_refresh);
    sortByNotifier.removeListener(_refresh);
  }

  void _refresh() {
    pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final projects = await db.queryProjects(
        sortBy: sortByNotifier.value.$1,
        ascending: sortByNotifier.value.$2,
        offset: pageKey * _kPageSize,
        searchQuery: searchQueryNotifier.text,
      );
      final isLastPage = projects.length < _kPageSize;
      if (isLastPage) {
        pagingController.appendLastPage(projects);
      } else {
        pagingController.appendPage(projects, pageKey + 1);
      }
    } catch (e) {
      pagingController.error = e;
    }
  }

  Future<void> onProjectAdded(BuildContext context, int projectId) async {
    final project = await db.getProject(projectId);
    if (!context.mounted) return;
    final c = pagingController;
    c.itemList = List.of(c.itemList ?? [])..insert(0, project);
    context.read<_SortByNotifier>().value = (ProjectSortBy.createdAt, false);
  }

  Future<void> onProjectDeleted(BuildContext context, int projectId) async {
    final c = pagingController;
    c.itemList = List.of(c.itemList ?? [])
      ..removeWhere((p) => p.id == projectId);
  }
}
