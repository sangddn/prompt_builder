part of '../snippets_page.dart';

const _kPageSize = 50;

final class _SnippetsController implements InfinityController<Snippet> {
  _SnippetsController({
    required this.db,
    required this.searchQueryNotifier,
    required this.sortByNotifier,
  });

  final Database db;
  final _SearchQueryNotifier searchQueryNotifier;
  final _SortByNotifier sortByNotifier;

  @override
  final pagingController = PagingController<int, Snippet>(firstPageKey: 0);

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
      final snippets = await db.querySnippets(
        sortBy: sortByNotifier.value.$1,
        ascending: sortByNotifier.value.$2,
        offset: pageKey * _kPageSize,
        searchQuery: searchQueryNotifier.text,
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
}
