part of 'prompt_grid.dart';

const _kPageSize = 50;
typedef PromptSortByNotifier = ValueNotifier<(PromptSortBy, bool ascending)>;
typedef ProjectIdNotifier = ValueNotifier<Value<int?>>;

final class PromptSearchQueryNotifier extends TextEditingController {}

final class PromptGridController implements InfinityController<Prompt> {
  PromptGridController({
    required this.db,
    required this.filterTagNotifier,
    required this.searchQueryNotifier,
    required this.sortByNotifier,
    required this.projectIdNotifier,
  });

  final Database db;
  final TagFilterNotifier? filterTagNotifier;
  final PromptSearchQueryNotifier? searchQueryNotifier;
  final PromptSortByNotifier? sortByNotifier;
  final ProjectIdNotifier? projectIdNotifier;

  @override
  final pagingController = PagingController<int, Prompt>(firstPageKey: 0);

  @override
  void init() {
    pagingController.addPageRequestListener(_fetchPage);
    filterTagNotifier?.addListener(_refresh);
    searchQueryNotifier?.addListener(_refresh);
    sortByNotifier?.addListener(_refresh);
    projectIdNotifier?.addListener(_refresh);
  }

  @override
  void dispose() {
    pagingController.dispose();
    filterTagNotifier?.removeListener(_refresh);
    searchQueryNotifier?.removeListener(_refresh);
    sortByNotifier?.removeListener(_refresh);
    projectIdNotifier?.removeListener(_refresh);
  }

  void _refresh() {
    pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final prompts = await db.queryPrompts(
        sortBy: sortByNotifier?.value.$1 ?? PromptSortBy.createdAt,
        ascending: sortByNotifier?.value.$2 ?? false,
        // NOT Value.absent() -- defaults to non-project prompts
        projectId: projectIdNotifier?.value ?? const Value(null),
        tags: filterTagNotifier?.value?.let((it) => [it]) ?? const [],
        searchQuery: searchQueryNotifier?.text ?? '',
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

  void onPromptDeleted(Prompt prompt) {
    final c = pagingController;
    c.itemList = List.of(c.itemList ?? [])
      ..removeWhere((p) => p.id == prompt.id);
  }

  Future<void> onPromptAdded(int newPromptId) async {
    final c = pagingController;
    final newPrompt = await db.getPrompt(newPromptId);
    c.itemList = List.of(c.itemList ?? [])..insert(0, newPrompt);
  }

  Future<void> reloadPrompt(BuildContext context, int promptId) async {
    final c = pagingController;
    final newPrompt = await db.getPrompt(promptId);
    if (!context.mounted) return;
    final index = c.itemList?.indexWhere((p) => p.id == promptId);
    if (index == null || index == -1) return;
    c.itemList = List.of(c.itemList ?? [])
      ..removeAt(index)
      ..insert(index, newPrompt);
  }
}
