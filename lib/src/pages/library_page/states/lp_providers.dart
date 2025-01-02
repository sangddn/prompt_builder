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

  void _onNewPromptAddedOrEdited(int id) => WidgetsBinding.instance
      .addPostFrameCallback((_) => _controller._refresh());

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<Database>.value(value: widget.db),
          ValueProvider<_FilterTagNotifier>(
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
              observer.addNewPromptListener(_onNewPromptAddedOrEdited);
              observer.addPromptTitleOrDescriptionChangedListener(
                _onNewPromptAddedOrEdited,
              );
              return _controller;
            },
            dispose: (_, controller) {
              controller.dispose();
              final observer = LibraryObserver.of(context);
              observer.removeNewPromptListener(_onNewPromptAddedOrEdited);
              observer.removePromptTitleOrDescriptionChangedListener(
                _onNewPromptAddedOrEdited,
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

typedef _FilterTagNotifier = ValueNotifier<String?>;
typedef _SearchQueryNotifier = TextEditingController;
typedef _SortByNotifier = ValueNotifier<(PromptSortBy, bool)>;

// -----------------------------------------------------------------------------
// Providers
// -----------------------------------------------------------------------------

/// Creates a [ValueNotifier] that persists the sort by and ascending state to the
/// database.
_SortByNotifier _createSortByNotifier(Database db) {
  final sortBy = db.stringRef //
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

// -----------------------------------------------------------------------------
// Extensions
// -----------------------------------------------------------------------------

extension _LPProvidersExtension on BuildContext {
  Database get db => read<Database>();
}
