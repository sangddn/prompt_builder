part of '../snippet_page.dart';

class _SnippetProviders extends StatelessWidget {
  const _SnippetProviders({
    required this.id,
    required this.onSaved,
    required this.child,
  });

  final int id;
  final VoidCallback? onSaved;
  final Widget child;

  @override
  Widget build(BuildContext context) => FutureProvider<Snippet?>(
    initialData: null,
    create: (context) => context.db.getSnippet(id),
    builder: (context, child) {
      final snippet = context.watchSnippet();
      if (snippet == null) return child!;
      return _MoreProviders(context.db, id, onSaved, child: child!);
    },
    child: child,
  );
}

class _MoreProviders extends MultiProviderWidget {
  const _MoreProviders(this.db, this.id, this.onSaved, {required this.child});

  final Database db;
  final int id;
  final VoidCallback? onSaved;
  final Widget child;

  @override
  List<SingleChildWidget> get providers => [
    ValueProvider<_TitleController>(
      create: (context) => _TitleController(text: context.snippet!.title),
      onDisposed: (context, controller) {
        final title = controller?.text.trim();
        if (title == null) return;
        db.updateSnippet(id, title: title);
      },
    ),
    ValueProvider<_ContentController>(
      create: (context) => _ContentController(text: context.snippet!.content),
      onDisposed: (context, controller) {
        final text = controller?.text.trim();
        if (text == null) return;
        db.updateSnippet(id, content: text);
      },
    ),
    ProxyProvider<_ContentController, IMap<String, String>>(
      create: (context) => IMap(context.snippet!.variables),
      update: (_, controller, _) {
        return IMap(SnippetExtension.parseVariables(controller.text));
      },
    ),
    ValueProvider<_NotesController>(
      create: (context) => _NotesController(text: context.snippet!.notes),
      onDisposed: (context, controller) {
        final notes = controller?.text.trim();
        if (notes == null) return;
        db.updateSnippet(id, notes: notes);
      },
    ),
    ValueProvider<_TagsNotifier>(
      create: (context) => _TagsNotifier(IList(context.snippet!.tagsList)),
      onDisposed: (context, notifier) {
        final tags = notifier?.value;
        if (tags == null) return;
        db.updateSnippet(id, tags: tags.unlockView);
      },
    ),
  ];

  @override
  Widget buildChild(BuildContext context) => child;
}

class _TitleController extends TextEditingController {
  _TitleController({super.text});
}

class _ContentController extends TextEditingController {
  _ContentController({super.text});
}

class _NotesController extends TextEditingController {
  _NotesController({super.text});
}

typedef _TagsNotifier = ValueNotifier<IList<String>>;

extension _SnippetPageExtension on BuildContext {
  Snippet? get snippet => read();
  Snippet? watchSnippet() => watch();

  _ContentController? get contentController => read();
  _ContentController? watchContent() => watch();
  _NotesController? get notesController => read();
  _TagsNotifier? watchTags() => watch();

  void addTag(String tag) {
    final n = read<_TagsNotifier>();
    n.value = n.value.add(tag);
  }

  void removeTag(String tag) {
    final n = read<_TagsNotifier>();
    n.value = n.value.remove(tag);
  }
}
