part of '../snippets_page.dart';

class _SNPProviders extends StatelessWidget {
  const _SNPProviders({required this.db, required this.child});

  final Database db;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<Database>.value(value: db),
          ChangeNotifierProvider<_SearchQueryNotifier>(
            create: (_) => TextEditingController(),
          ),
          ChangeNotifierProvider<_SortByNotifier>(
            create: (_) => ValueNotifier((SnippetSortBy.createdAt, false)),
          ),
          Provider<_SnippetsController>(
            create: (context) => _SnippetsController(
              db: context.read<Database>(),
              sortByNotifier: context.read(),
              searchQueryNotifier: context.read(),
            ),
          ),
        ],
        child: child,
      );
}

typedef _SearchQueryNotifier = TextEditingController;
typedef _SortByNotifier = ValueNotifier<(SnippetSortBy, bool)>;
