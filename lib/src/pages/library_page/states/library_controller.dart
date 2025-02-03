part of '../library_page.dart';

const _kPageSize = 50;

final class _LibraryController implements InfinityController<Prompt> {
  _LibraryController({
    required this.db,
    required this.filterTagNotifier,
    required this.searchQueryNotifier,
    required this.sortByNotifier,
  });

  final Database db;
  final TagFilterNotifier filterTagNotifier;
  final _SearchQueryNotifier searchQueryNotifier;
  final _SortByNotifier sortByNotifier;

  @override
  final pagingController = PagingController<int, Prompt>(firstPageKey: 0);

  @override
  void init() {
    pagingController.addPageRequestListener(_fetchPage);
    filterTagNotifier.addListener(_refresh);
    searchQueryNotifier.addListener(_refresh);
    sortByNotifier.addListener(_refresh);
  }

  @override
  void dispose() {
    pagingController.dispose();
    filterTagNotifier.removeListener(_refresh);
    searchQueryNotifier.removeListener(_refresh);
    sortByNotifier.removeListener(_refresh);
  }

  void _refresh() {
    pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final prompts = await db.queryPrompts(
        sortBy: sortByNotifier.value.$1,
        ascending: sortByNotifier.value.$2,
        projectId:
            sortByNotifier.value.$3 ? const Value.absent() : const Value(null),
        tags: filterTagNotifier.value?.let((it) => [it]) ?? const [],
        searchQuery: searchQueryNotifier.text,
        // ignore: avoid_redundant_argument_values
        limit: _kPageSize,
        offset: pageKey * _kPageSize,
      );
      final isLastPage = prompts.length < _kPageSize;
      if (isLastPage) {
        pagingController.appendLastPage(prompts);
      } else {
        pagingController.appendPage(prompts, pageKey + 1);
      }
    } catch (e) {
      pagingController.error = e;
    }
  }
}
