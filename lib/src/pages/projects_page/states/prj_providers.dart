part of '../projects_page.dart';

class _PRJProviders extends StatelessWidget {
  const _PRJProviders({required this.db, required this.child});

  final Database db;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Database>.value(value: db),
        ChangeNotifierProvider<ProjectQueryNotifier>(
          create: (_) => ProjectQueryNotifier(),
        ),
        ChangeNotifierProvider<ProjectSortByNotifier>(
          create:
              (_) =>
                  ValueNotifier((ProjectSortBy.updatedAt, false, null, true)),
        ),
        Provider<ProjectListController>(
          create:
              (context) => ProjectListController(
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

extension _ProjectsPageContext on BuildContext {
  ProjectListController get controller => read();
}
