part of 'snippet_list.dart';

const _kPageSize = 50;
typedef SnippetSortByNotifier = ValueNotifier<(SnippetSortBy, bool)>;

final class SnippetSearchQueryNotifier extends TextEditingController {}

final class SnippetListController implements InfinityController<Snippet> {
  SnippetListController({
    required this.db,
    required this.searchQueryNotifier,
    required this.sortByNotifier,
    required this.filterTagNotifier,
    required this.projectIdNotifier,
  });

  final Database db;
  final SnippetSearchQueryNotifier? searchQueryNotifier;
  final SnippetSortByNotifier? sortByNotifier;
  final TagFilterNotifier? filterTagNotifier;
  final ProjectIdNotifier? projectIdNotifier;

  @override
  final pagingController = PagingController<int, Snippet>(firstPageKey: 0);

  @override
  void init() {
    pagingController.addPageRequestListener(_fetchPage);
    searchQueryNotifier?.addListener(refresh);
    sortByNotifier?.addListener(refresh);
    filterTagNotifier?.addListener(refresh);
    projectIdNotifier?.addListener(refresh);
  }

  @override
  void dispose() {
    pagingController.dispose();
    searchQueryNotifier?.removeListener(refresh);
    sortByNotifier?.removeListener(refresh);
    filterTagNotifier?.removeListener(refresh);
    projectIdNotifier?.removeListener(refresh);
  }

  void refresh() {
    pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final snippets = await db.querySnippets(
        sortBy: sortByNotifier?.value.$1 ?? SnippetSortBy.createdAt,
        ascending: sortByNotifier?.value.$2 ?? false,
        limit: _kPageSize, // ignore: avoid_redundant_argument_values
        offset: pageKey * _kPageSize,
        searchQuery: searchQueryNotifier?.text ?? '',
        tags: filterTagNotifier?.value != null
            ? [filterTagNotifier!.value!]
            : const [],
        // NOT Value.absent() -- defaults to non-project snippets
        projectId: projectIdNotifier?.value ?? const Value(null),
      );
      final isLastPage = snippets.length < _kPageSize;
      if (isLastPage) {
        pagingController.appendLastPage(snippets);
      } else {
        pagingController.appendPage(snippets, pageKey + 1);
      }
    } catch (e) {
      pagingController.error = e;
    }
  }

  Future<void> onSnippetDeleted(int snippetId) async {
    final c = pagingController;
    c.itemList = List.of(c.itemList ?? [])
      ..removeWhere((s) => s.id == snippetId);
  }

  Future<void> onSnippetCreated(BuildContext context, int snippetId) async {
    final c = pagingController;
    final snippet = await context.db.getSnippet(snippetId);
    if (!context.mounted) return;
    c.itemList = List.of(c.itemList ?? [])..insert(0, snippet);
  }

  Future<void> reloadSnippet(BuildContext context, int snippetId) async {
    final c = pagingController;
    final newSnippet = await context.db.getSnippet(snippetId);
    if (!context.mounted) return;
    final index = c.itemList?.indexWhere((s) => s.id == snippetId);
    if (index == null || index == -1) return;
    c.itemList = List.of(c.itemList ?? [])
      ..removeAt(index)
      ..insert(index, newSnippet);
  }
}
