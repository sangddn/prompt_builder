// ignore_for_file: avoid_types_as_parameter_names

part of '../resources_page.dart';

class _RPProviders extends StatelessWidget {
  const _RPProviders({required this.db, required this.child});

  final Database db;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final toaster = context.toaster;
    return MultiProvider(
      providers: [
        Provider<Database>.value(value: db),
        FutureProvider<SnippetResources?>(
          initialData: null,
          create: (_) => SnippetResourceService.fetchSnippetResources(),
          catchError: (context, error) {
            debugPrint('Error fetching snippet resources: $error');
            toaster.show(
              ShadToast.destructive(
                title: const Text('Failed to fetch snippet resources.'),
                description: Text(error.toString()),
              ),
            );
            return null;
          },
        ),
        ProxyProvider<SnippetResources?, _OrganizedResources?>(
          update: (_, r, __) => r?.let(_organize),
        ),
        ListenableProvider<ScrollController>(create: (_) => ScrollController()),
        ListenableProvider<ListController>(create: (_) => ListController()),
      ],
      child: child,
    );
  }
}

typedef _OrganizedResources = IMap<String, SnippetResources>;

_OrganizedResources _organize(SnippetResources r) {
  final allTags = r.expand((r) => r.tags).toSet();
  return IMap.fromKeys(
    keys: allTags,
    valueMapper: (tag) => r.where((r) => r.tags.contains(tag)).toIList(),
  );
}

extension _SnippetResourcesExtension on BuildContext {
  T selectResources<T>(T Function(_OrganizedResources?) fn) => select(fn);
  bool isLoading() => selectResources((r) => r == null);

  Future<void> saveResource(SnippetResource resource) async {
    final toaster = this.toaster;
    try {
      await db.createSnippet(title: resource.title, content: resource.content);
      toaster.show(
        ShadToast(
          title: const Text('Snippet saved.'),
          description: Text(resource.content, maxLines: 5),
        ),
      );
    } catch (e) {
      toaster.show(
        ShadToast.destructive(
          title: const Text('Failed to save snippet.'),
          description: Text(e.toString()),
        ),
      );
    }
  }

  void animateToSection(String tag) {
    final index = read<_OrganizedResources?>()?.keys.toList().indexOf(tag);
    if (index == null) return;
    read<ListController>().animateToItem(
      index: index,
      scrollController: read(),
      alignment: 0.25,
      duration: (_) => const Duration(seconds: 1),
      curve: (_) => Effects.snappyOutCurve,
    );
  }
}
