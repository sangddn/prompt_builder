part of '../project_page.dart';

class _PRPProviders extends StatelessWidget {
  const _PRPProviders({required this.id, required this.child});

  final int id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureProvider<Project?>(
      initialData: null,
      create: (context) => context.db.getProject(id),
      child: _MoreProviders(id: id, child: child),
    );
  }
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
    return providers
      ..addAll([
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
          create: (context) => SnippetListController(
            db: db,
            projectIdNotifier: context.read(),
            filterTagNotifier: context.read<_SnippetTagNotifier>(),
            searchQueryNotifier: null,
            sortByNotifier: null,
          ),
        ),
        Provider<PromptGridController>(
          create: (context) => PromptGridController(
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

class _TitleController extends TextEditingController {
  _TitleController({super.text});
}

class _NotesController extends TextEditingController {
  _NotesController({super.text});
}

class _SnippetTagNotifier extends TagFilterNotifier {
  _SnippetTagNotifier(super.value);
}

class _PromptTagNotifier extends TagFilterNotifier {
  _PromptTagNotifier(super.value);
}

extension _ProjectExtension on BuildContext {
  Project? get project => read<Project?>();
  bool isReady() => select((Project? p) => p != null);
}
