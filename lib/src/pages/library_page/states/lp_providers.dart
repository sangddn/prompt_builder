part of '../library_page.dart';

class _LPProviders extends MultiProviderWidget {
  const _LPProviders({required this.child});

  final Widget child;

  @override
  List<SingleChildWidget> getProviders(BuildContext context) {
    final db = context.read<Database>();
    final observer = LibraryObserver.of(context);
    return [
      ValueProvider<TagFilterNotifier>(create: (_) => ValueNotifier(null)),
      ChangeNotifierProvider<PromptSearchQueryNotifier>(
        create: (_) => PromptSearchQueryNotifier(),
      ),
      ChangeNotifierProvider<PromptSortByNotifier>(
        create: (_) => _createSortByNotifier(db),
      ),
      ChangeNotifierProvider<ProjectIdNotifier>(
        create: (_) => _createProjectIdNotifier(db),
      ),
      Provider<PromptGridController>(
        create: (context) {
          final controller = PromptGridController(
            db: db,
            sortByNotifier: context.read(),
            filterTagNotifier: context.read(),
            searchQueryNotifier: context.read(),
            projectIdNotifier: context.read(),
          );
          observer.addNewPromptListener(controller.onPromptAdded);
          return controller;
        },
        dispose: (_, controller) {
          observer.removeNewPromptListener(controller.onPromptAdded);
        },
      ),
    ];
  }

  @override
  Widget buildChild(BuildContext context) => child;
}

// -----------------------------------------------------------------------------
// Providers
// -----------------------------------------------------------------------------

const _kSortByKey = 'library_sort_key';
const _kSortByAscending = 'library_sort_by_ascending';
const _kHasProject = 'library_has_project';

/// Creates a [ValueNotifier] that persists the sort by and ascending state to the
/// database.
PromptSortByNotifier _createSortByNotifier(Database db) {
  final sortBy =
      db
          .stringRef //
          .get(_kSortByKey)
          ?.let((x) => PromptSortBy.values.firstWhere((v) => v.name == x)) ??
      PromptSortBy.createdAt;
  final ascending = db.boolRef.get(_kSortByAscending) ?? false;
  final notifier = ValueNotifier((sortBy, ascending));
  notifier.addListener(() {
    db.stringRef.put(_kSortByKey, notifier.value.$1.name);
    db.boolRef.put(_kSortByAscending, notifier.value.$2);
  });
  return notifier;
}

/// Creates a [ValueNotifier] that persists the project id to the database.
ProjectIdNotifier _createProjectIdNotifier(Database db) {
  final hasProject = db.boolRef.get(_kHasProject) ?? false;
  final Value<int?> val = hasProject ? const Value.absent() : const Value(null);
  final notifier = ValueNotifier(val);
  notifier.addListener(() {
    final hasProject = !notifier.value.present;
    db.boolRef.put(_kHasProject, hasProject);
  });
  return notifier;
}
