part of 'project_list.dart';

const _kPageSize = 50;

/// Type signature for the notifier that holds the sort by state.
///
/// - [sortBy] The sort by value.
/// - [ascending] Whether the sort is ascending.
/// - [isStarred] Whether the sort is starred only, unstarred only, or all (null).
/// - [prioritizeStarred] Whether to prioritize starred projects.
typedef ProjectSortByNotifier = ValueNotifier<
    (
      ProjectSortBy sortBy,
      bool ascending,
      bool? isStarred,
      bool prioritizeStarred,
    )>;

final class ProjectQueryNotifier extends TextEditingController {}

final class ProjectListController implements InfinityController<Project> {
  ProjectListController({
    required this.db,
    required this.searchQueryNotifier,
    required this.sortByNotifier,
  });

  final Database db;
  final ProjectQueryNotifier searchQueryNotifier;
  final ProjectSortByNotifier sortByNotifier;

  @override
  final pagingController = PagingController<int, Project>(firstPageKey: 0);

  @override
  void init() {
    pagingController.addPageRequestListener(_fetchPage);
    searchQueryNotifier.addListener(refresh);
    sortByNotifier.addListener(refresh);
  }

  @override
  void dispose() {
    pagingController.dispose();
    searchQueryNotifier.removeListener(refresh);
    sortByNotifier.removeListener(refresh);
  }

  void refresh() {
    pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final projects = await db.queryProjects(
        sortBy: sortByNotifier.value.$1,
        ascending: sortByNotifier.value.$2,
        offset: pageKey * _kPageSize,
        searchQuery: searchQueryNotifier.text,
        isStarred: sortByNotifier.value.$3,
        prioritizeStarred: sortByNotifier.value.$4,
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
    final notifier = context.read<ProjectSortByNotifier>();
    final v = notifier.value;
    notifier.value = (ProjectSortBy.createdAt, false, v.$3, v.$4);
  }

  void onProjectDeleted(int projectId) {
    final c = pagingController;
    c.itemList = List.of(c.itemList ?? [])
      ..removeWhere((p) => p.id == projectId);
  }

  Future<void> reloadProject(BuildContext context, int projectId) async {
    final c = pagingController;
    final newProject = await context.db.getProject(projectId);
    if (!context.mounted) return;
    final index = c.itemList?.indexWhere((p) => p.id == projectId);
    if (index == null || index == -1) return;
    c.itemList = List.of(c.itemList ?? [])
      ..removeAt(index)
      ..insert(index, newProject);
  }

  Future<void> moveToTop(int projectId) async {
    final c = pagingController;
    final index = c.itemList?.indexWhere((p) => p.id == projectId);
    if (index == null || index == -1) return;
    final project = c.itemList?[index];
    if (project == null) return;
    c.itemList = List.of(c.itemList ?? [])
      ..removeWhere((p) => p.id == projectId)
      ..insert(0, project);
  }

  Future<void> moveToAfterLastStarredProject(int projectId) async {
    final c = pagingController;
    final list = c.itemList;
    if (list == null) return;
    final index = list.indexWhere((p) => p.id == projectId);
    if (index == -1) return;
    final project = list[index];
    list.removeAt(index);
    final indexOfLastStarredProject = list.lastIndexWhere((p) => p.isStarred);
    c.itemList = List.of(list)..insert(indexOfLastStarredProject + 1, project);
  }
}
