part of '../library_page.dart';

class _LPProviders extends StatefulWidget {
  const _LPProviders({
    required this.db,
    required this.child,
  });

  final Database db;
  final Widget child;

  @override
  State<_LPProviders> createState() => _LPProvidersState();
}

class _LPProvidersState extends State<_LPProviders> {
  late final _LibraryController _controller;

  void _onPromptEdited(int id) =>
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final c = _controller.pagingController;
        final newPrompt = await widget.db.getPrompt(id);
        final index = c.itemList?.indexWhere((p) => p.id == id);
        if (index == null || index == -1) return;
        c.itemList = List.of(c.itemList ?? [])
          ..removeAt(index)
          ..insert(index, newPrompt);
      });

  void _onNewPromptAdded(int id) =>
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final c = _controller.pagingController;
        final newPrompt = await widget.db.getPrompt(id);
        c.itemList = List.of(c.itemList ?? [])..insert(0, newPrompt);
      });

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<Database>.value(value: widget.db),
          ValueProvider<TagFilterNotifier>(
            create: (_) => ValueNotifier(null),
          ),
          ChangeNotifierProvider<_SearchQueryNotifier>(
            create: (_) => TextEditingController(),
          ),
          ChangeNotifierProvider<_SortByNotifier>(
            create: (_) => _createSortByNotifier(widget.db),
          ),
          Provider<_LibraryController>(
            create: (context) {
              _controller = _LibraryController(
                db: widget.db,
                sortByNotifier: context.read(),
                filterTagNotifier: context.read(),
                searchQueryNotifier: context.read(),
              );
              final observer = LibraryObserver.of(context);
              observer.addNewPromptListener(_onNewPromptAdded);
              observer.addPromptTitleOrNotesChangedListener(_onPromptEdited);
              return _controller;
            },
            dispose: (_, controller) {
              controller.dispose();
              final observer = LibraryObserver.of(context);
              observer.removeNewPromptListener(_onNewPromptAdded);
              observer.removePromptTitleOrNotesChangedListener(
                _onPromptEdited,
              );
            },
          ),
        ],
        child: widget.child,
      );
}

// -----------------------------------------------------------------------------
// Enums & Typedefs
// -----------------------------------------------------------------------------

typedef _SearchQueryNotifier = TextEditingController;
typedef _SortByNotifier
    = ValueNotifier<(PromptSortBy, bool ascending, bool hasProject)>;

// -----------------------------------------------------------------------------
// Providers
// -----------------------------------------------------------------------------

const _kSortByKey = 'library_sort_key';
const _kSortByAscending = 'library_sort_by_ascending';
const _kHasProject = 'library_has_project';

/// Creates a [ValueNotifier] that persists the sort by and ascending state to the
/// database.
_SortByNotifier _createSortByNotifier(Database db) {
  final sortBy = db.stringRef //
          .get(_kSortByKey)
          ?.let((x) => PromptSortBy.values.firstWhere((v) => v.name == x)) ??
      PromptSortBy.createdAt;
  final ascending = db.boolRef.get(_kSortByAscending) ?? false;
  final hasProject = db.boolRef.get(_kHasProject) ?? false;
  final notifier = ValueNotifier((sortBy, ascending, hasProject));
  notifier.addListener(() {
    db.stringRef.put(_kSortByKey, notifier.value.$1.name);
    db.boolRef.put(_kSortByAscending, notifier.value.$2);
    db.boolRef.put(_kHasProject, notifier.value.$3);
  });
  return notifier;
}

// -----------------------------------------------------------------------------
// Extensions
// -----------------------------------------------------------------------------

extension _LPProvidersExtension on BuildContext {
  Database get db => read<Database>();
}
