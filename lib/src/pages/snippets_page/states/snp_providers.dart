part of '../snippets_page.dart';

class _SNPProviders extends StatelessWidget {
  const _SNPProviders({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<_SearchQueryNotifier>(
            create: (_) => TextEditingController(),
          ),
          ChangeNotifierProvider<_SortByNotifier>(
            create: (_) => ValueNotifier((SnippetSortBy.createdAt, false)),
          ),
          ChangeNotifierProvider<TagFilterNotifier>(
            create: (_) => ValueNotifier(null),
          ),
          Provider<_SnippetsController>(
            create: (context) => _SnippetsController(
              db: context.db,
              sortByNotifier: context.read(),
              searchQueryNotifier: context.read(),
              filterTagNotifier: context.read(),
            ),
          ),
        ],
        child: child,
      );
}

typedef _SearchQueryNotifier = TextEditingController;
typedef _SortByNotifier = ValueNotifier<(SnippetSortBy, bool)>;
