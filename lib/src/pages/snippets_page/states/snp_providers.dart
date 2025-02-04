part of '../snippets_page.dart';

class _SNPProviders extends StatelessWidget {
  const _SNPProviders({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<SnippetSearchQueryNotifier>(
            create: (_) => SnippetSearchQueryNotifier(),
          ),
          ChangeNotifierProvider<SnippetSortByNotifier>(
            create: (_) => ValueNotifier((SnippetSortBy.createdAt, false)),
          ),
          ChangeNotifierProvider<TagFilterNotifier>(
            create: (_) => ValueNotifier(null),
          ),
          ChangeNotifierProvider<ProjectIdNotifier>(
            create: (context) => _createProjectIdNotifier(context.db),
          ),
          Provider<SnippetListController>(
            create: (context) => SnippetListController(
              db: context.db,
              sortByNotifier: context.read(),
              searchQueryNotifier: context.read(),
              filterTagNotifier: context.read(),
              projectIdNotifier: context.read(),
            ),
          ),
        ],
        child: child,
      );
}

const _kHasProject = 'snippets_page_has_project';

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
