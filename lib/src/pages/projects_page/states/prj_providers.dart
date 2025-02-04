part of '../projects_page.dart';

class _PRJProviders extends StatelessWidget {
  const _PRJProviders({
    required this.db,
    required this.child,
  });

  final Database db;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Database>.value(value: db),
        ChangeNotifierProvider<_SearchQueryNotifier>(
          create: (_) => TextEditingController(),
        ),
        ChangeNotifierProvider<_SortByNotifier>(
          create: (_) => ValueNotifier((ProjectSortBy.updatedAt, false)),
        ),
        Provider<_ProjectsController>(
          create: (context) => _ProjectsController(
            db: context.db,
            sortByNotifier: context.read(),
            searchQueryNotifier: context.read(),
          ),
        ),
      ],
      child: child,
    );
  }
}

typedef _SearchQueryNotifier = TextEditingController;
typedef _SortByNotifier = ValueNotifier<(ProjectSortBy, bool)>;

extension _ProjectsPageContext on BuildContext {
  _ProjectsController get controller => read<_ProjectsController>();
}
