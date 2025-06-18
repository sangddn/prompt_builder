part of '../project_page.dart';

class _PRPProviders extends MultiProviderWidget {
  const _PRPProviders({required this.id, required this.child});

  final int id;
  final Widget child;

  @override
  List<SingleChildWidget> get providers => [
    ValueProvider<_SnippetGridStateNotifier>(
      create: (_) => _SnippetGridStateNotifier(),
    ),
    ValueProvider<_PromptGridStateNotifier>(
      create: (_) => _PromptGridStateNotifier(),
    ),
    FutureProvider<Project?>(
      initialData: null,
      create: (context) => context.db.getProject(id),
    ),
  ];

  @override
  Widget buildChild(BuildContext context) =>
      _MoreProviders(id: id, child: child);
}

class _MoreProviders extends MultiProviderWidget {
  const _MoreProviders({required this.id, required this.child});

  final int id;
  final Widget child;

  @override
  List<SingleChildWidget> getProviders(BuildContext context) {
    final providers = <SingleChildWidget>[
      ValueProvider<ProjectIdNotifier>(
        create: (_) => ProjectIdNotifier(Value(id)),
      ),
      ValueProvider<_SnippetTagNotifier>(
        create: (_) => _SnippetTagNotifier(null),
      ),
      ValueProvider<_PromptTagNotifier>(
        create: (_) => _PromptTagNotifier(null),
      ),
    ];
    if (context.select((Project? p) => p == null)) {
      return providers;
    }
    final db = context.db;
    return providers..addAll([
      ValueProvider<_TitleController>(
        create: (context) => _TitleController(text: context.project!.title),
        onDisposed: (context, controller) {
          final title = controller?.text.trim();
          if (title == null) return;
          db.updateProject(id, title: title);
        },
      ),
      ValueProvider<_NotesController>(
        create: (context) => _NotesController(text: context.project!.notes),
        onDisposed: (context, controller) {
          final notes = controller?.text.trim();
          if (notes == null) return;
          db.updateProject(id, notes: notes);
        },
      ),
      Provider<SnippetListController>(
        create:
            (context) => SnippetListController(
              db: db,
              projectIdNotifier: context.read(),
              filterTagNotifier: context.read<_SnippetTagNotifier>(),
              searchQueryNotifier: null,
              sortByNotifier: null,
            ),
      ),
      Provider<PromptGridController>(
        create:
            (context) => PromptGridController(
              db: db,
              projectIdNotifier: context.read(),
              filterTagNotifier: context.read<_PromptTagNotifier>(),
              searchQueryNotifier: null,
              sortByNotifier: null,
            ),
      ),
    ]);
  }

  @override
  Widget buildChild(BuildContext context) => child;
}
