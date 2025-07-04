part of '../prompt_page.dart';

Future<void> _showWebSearchDialog(BuildContext context) => showPDialog<void>(
  context: context,
  barrierColor: Colors.transparent,
  builder:
      (_) => MultiProvider(
        providers: [
          Provider<Database>.value(value: context.db),
          Provider<Prompt?>.value(value: context.prompt),
        ],
        child: const _PPWebSearchDialog(),
      ),
);

class _WebSearchButton extends StatelessWidget {
  const _WebSearchButton();

  @override
  Widget build(BuildContext context) {
    return CButton(
      tooltip: 'Search and add content from the web.',
      onTap: () => _showWebSearchDialog(context),
      padding: k16H8VPadding,
      color: PColors.lightGray.resolveFrom(context),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                HugeIcons.strokeRoundedGlobalSearch,
                size: 18.0,
                color: PColors.textGray.resolveFrom(context),
              ),
              const SizedBox(width: 4.0),
              Text('Web', style: context.textTheme.muted),
            ],
          ),
          Text.rich(
            keyboardShortcutSpan(
              context,
              true,
              false,
              'F',
              PColors.darkGray.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _PPWebSearchDialog extends StatelessWidget {
  const _PPWebSearchDialog();

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: MultiProvider(
        providers: [
          StreamProvider<SearchProvider?>(
            initialData:
                SearchProviderPreference.getValidProviderWithFallback(),
            create:
                (_) =>
                    SearchProviderPreference.streamValidProviderWithFallback(),
          ),
          ValueProvider<ValueNotifier<_WebSearchState>>(
            create: (_) => ValueNotifier(_WebSearchState.idle),
          ),
          ValueProvider<ValueNotifier<_SearchBarIntent>>(
            create: (_) => ValueNotifier(_SearchBarIntent.search),
          ),
          ValueProvider<TextEditingController>(
            create: (_) => TextEditingController(),
            onNotified: _inferIntent,
          ),
          ListenableProvider(create: (_) => FocusNode()),
          ValueProvider<_WebResultsNotifier>(
            create: (_) => _WebResultsNotifier(const IList.empty()),
          ),
        ],
        child: Align(
          alignment: const Alignment(0.0, -0.4),
          child: Container(
            decoration: ShapeDecoration(
              color: context.brightSurface,
              shape: Superellipse(
                cornerRadius: 12.0,
                side: BorderSide(
                  width: .15,
                  color: PColors.opagueGray.resolveFrom(context),
                ),
              ),
              shadows: [
                ...mediumShadows(),
                BoxShadow(
                  color: Colors.black.replaceOpacity(.1),
                  blurRadius: 48.0,
                  spreadRadius: 8.0,
                ),
              ],
            ),
            width: 600.0,
            height: 500.0,
            clipBehavior: Clip.hardEdge,
            child: const Material(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomScrollView(
                    slivers: [
                      PinnedHeaderSliver(
                        child: Column(
                          children: [
                            _SearchBar(),
                            Divider(height: 1.0, thickness: 1.0),
                          ],
                        ),
                      ),
                      SliverGap(8.0),
                      SliverToBoxAdapter(child: _UnderneathSearchBarText()),
                      SliverGap(8.0),
                      _WebSearchResultList(),
                      SliverGap(128.0),
                    ],
                  ),
                  _ActionBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read(),
      focusNode: context.read(),
      autofocus: true,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
          child: Builder(
            builder: (context) {
              final isLoading = context.isSearching();
              final provider = context.watch<SearchProvider?>();
              return GrayShimmer(
                enableShimmer: isLoading,
                child:
                    provider == null
                        ? const Padding(
                          padding: k12HPadding,
                          child: Icon(
                            HugeIcons.strokeRoundedGlobe02,
                            size: 20.0,
                          ),
                        )
                        : ProviderPicker.searchWithDefaultUpdate(
                          initialProvider: provider,
                          decoration: const ShadDecoration(
                            border: ShadBorder(),
                          ),
                          builder:
                              (context, provider) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: ProviderLogo(provider: provider),
                              ),
                        ),
              );
            },
          ),
        ),
        hintText: 'Search',
        border: InputBorder.none,
        filled: true,
        fillColor: context.brightSurface,
        contentPadding: k24APadding,
      ),
      style: context.textTheme.list,
      onSubmitted: (query) => context._search(),
      // This ensures field stays focused when Enter is pressed.
      onEditingComplete: () {},
    );
  }
}

class _UnderneathSearchBarText extends AnimatedStatelessWidget {
  const _UnderneathSearchBarText();

  @override
  Widget buildAnimation(BuildContext context, Widget child) => DefaultTextStyle(
    style: context.textTheme.muted,
    child: TranslationSwitcher.top(
      offset: .2,
      duration: Effects.veryShortDuration,
      child: child,
    ),
  );

  @override
  Widget buildChild(BuildContext context) {
    if (context.isSearching()) {
      return const SizedBox(
        key: ValueKey('loading'),
        height: 40.0,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (context.selectWebResults((n) => n.value.isNotEmpty)) {
      return const SizedBox.shrink();
    }
    final provider = context.watch<SearchProvider?>();
    if (provider == null) {
      return const Padding(
        key: ValueKey('no-provider'),
        padding: k16H8VPadding,
        child: Text(
          'Set up a search provider in Settings to search.\nYou can still add URLs and YouTube videos.',
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _ActionBar extends AnimatedStatelessWidget {
  const _ActionBar();

  @override
  Widget buildChild(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [Divider(height: 1.0), Gap(12.0), _SearchActions(), Gap(12.0)],
    );
  }
}

class _SearchActions extends AnimatedStatelessWidget {
  const _SearchActions();

  @override
  Widget buildAnimation(BuildContext context, Widget child) =>
      TranslationSwitcher.top(
        offset: .2,
        duration: Effects.veryShortDuration,
        child: child,
      );

  @override
  Widget buildChild(BuildContext context) {
    if (!context.hasText()) {
      return Padding(
        padding: k16H8VPadding,
        child: Text(
          'Search web or paste a URL (webpage or YouTube)',
          style: context.textTheme.muted,
        ),
      );
    }
    final intent = context.watchIntent();
    final text = switch (intent) {
      _SearchBarIntent.search => 'Search',
      _SearchBarIntent.genericUrl => 'Extract & Add',
      _SearchBarIntent.youtubeUrl => 'Add Transcript',
    };
    final canAddMore =
        intent == _SearchBarIntent.genericUrl ||
        intent == _SearchBarIntent.youtubeUrl;
    var shouldAddMore = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (canAddMore)
          StatefulBuilder(
            builder: (context, setState) {
              final side = ShadBorderSide(
                color: PColors.darkGray.resolveFrom(context),
              );
              return ShadCheckbox(
                value: shouldAddMore,
                decoration: ShadDecoration(
                  border: ShadBorder(
                    radius: BorderRadius.circular(6.0),
                    top: side,
                    bottom: side,
                    left: side,
                    right: side,
                  ),
                ),
                onChanged: (value) => setState(() => shouldAddMore = value),
                padding: k4APadding,
                label: const Text('Add more'),
              );
            },
          ),
        const Gap(16.0),
        CButton(
          tooltip: null,
          color: context.theme.primaryButtonTheme.backgroundColor,
          padding: k16H4VPadding,
          onTap: () {
            context._search();
            if (canAddMore && shouldAddMore) {
              context.read<FocusNode>().requestFocus();
            } else if (canAddMore) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            text,
            style: context.textTheme.p.copyWith(
              color: context.theme.primaryButtonTheme.foregroundColor,
            ),
          ),
        ),
        const Gap(12.0),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Search Results
// -----------------------------------------------------------------------------

class _WebSearchResultList extends StatelessWidget {
  const _WebSearchResultList();

  @override
  Widget build(BuildContext context) {
    final count = context.select((_WebResultsNotifier n) => n.value.length);
    return SuperSliverList.builder(
      itemCount: count,
      itemBuilder:
          (context, index) => Builder(
            builder: (context) {
              final result = context.select(
                (_WebResultsNotifier n) => n.value.elementAtOrNull(index),
              );
              if (result == null) return const SizedBox.shrink();
              return _WebSearchResult(result);
            },
          ),
    );
  }
}

class _WebSearchResult extends StatelessWidget {
  const _WebSearchResult(this.result);

  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ShadPopoverController>(
      create: (_) => ShadPopoverController(),
      child: HoverTapBuilder(
        builder: (context, isHovered) {
          final provider = context.searchProvider;
          if (provider == null) return const SizedBox.shrink();
          Future<void> add() async {
            if (context.prompt?.id case final id?) {
              final toaster = context.toaster;
              try {
                await context.db.createWebBlockFromResult(id, result, provider);
                toaster.show(
                  ShadToast(
                    title: Text('Added content from ${result.url}.'),
                    description: Text(result.title, maxLines: 10),
                  ),
                );
              } catch (e) {
                toaster.show(
                  ShadToast.destructive(
                    title: Text('Error adding content from ${result.url}.'),
                    description: Text('$e'),
                  ),
                );
              }
            }
          }

          final trailing =
              isHovered
                  ? ShadBadge(onPressed: add, child: const Text('Add'))
                  : ShadBadge.secondary(
                    onPressed: add,
                    child: const Text('Add'),
                  );

          final controller = context.read<ShadPopoverController>();

          return ShadPopover(
            controller: controller,
            popover: (context) {
              return FutureProvider<String?>(
                initialData: null,
                create: (_) => result.getContent(provider),
                builder: (context, _) {
                  final content = context.watch<String?>();
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                      minWidth: 300,
                      minHeight: 200,
                      maxHeight: 700,
                    ),
                    child: SingleChildScrollView(
                      child:
                          content == null
                              ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                              : Text(content, style: context.textTheme.p),
                    ),
                  );
                },
              );
            },
            child: ShadContextMenuRegion(
              constraints: const BoxConstraints(minWidth: 200),
              items: [
                ShadContextMenuItem(
                  onPressed: () => controller.show(),
                  trailing: const Icon(LucideIcons.eye, size: 16.0),
                  child: const Text('Peek Content'),
                ),
                ShadContextMenuItem(
                  onPressed: () => launchUrlString(result.url),
                  trailing: const Icon(LucideIcons.arrowUpRight, size: 16.0),
                  child: const Text('Open in Browser'),
                ),
                ShadContextMenuItem(
                  onPressed: add,
                  trailing: const Icon(LucideIcons.plus, size: 16.0),
                  child: const Text('Add to Prompt'),
                ),
              ],
              child: ListTile(
                leading: result.faviconUrl?.let(
                  (url) => Image.network(url, width: 16.0, height: 16.0),
                ),
                title: Text(
                  result.title,
                  maxLines: 1,
                  style: context.textTheme.p,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.url,
                      maxLines: 1,
                      style: context.textTheme.muted,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (result.highlights.firstOrNull case final h?)
                      Text(
                        h,
                        maxLines: 1,
                        style: context.textTheme.muted,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                splashColor: Colors.transparent,
                onTap: add,
                trailing: trailing,
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Typedefs and Extensions
// -----------------------------------------------------------------------------

typedef _WebResults = IList<SearchResult>;
typedef _WebResultsNotifier = ValueNotifier<_WebResults>;

enum _SearchBarIntent { search, genericUrl, youtubeUrl }

enum _WebSearchState { idle, loading }

void _inferIntent(BuildContext context, TextEditingController? controller) {
  final text = controller?.text;
  if (text == null || text.isEmpty) return;
  final uri = Uri.tryParse(text);
  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
    context.intentNotifier.value = _SearchBarIntent.search;
    return;
  }
  if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
    context.intentNotifier.value = _SearchBarIntent.youtubeUrl;
    return;
  }
  context.intentNotifier.value = _SearchBarIntent.genericUrl;
}

extension _WebSearchSectionExtension on BuildContext {
  ValueNotifier<_SearchBarIntent> get intentNotifier => read();
  _SearchBarIntent watchIntent() =>
      watch<ValueNotifier<_SearchBarIntent>>().value;

  ValueNotifier<_WebSearchState> get searchStateNotifier => read();
  _WebSearchState watchSearchState() =>
      watch<ValueNotifier<_WebSearchState>>().value;
  bool isSearching() => watchSearchState() == _WebSearchState.loading;

  TextEditingController get controller => read();
  T selectController<T>(T Function(TextEditingController) fn) => select(fn);
  bool hasText() => selectController((c) => c.text.isNotEmpty);

  _WebResultsNotifier get webResultsNotifier => read();
  T selectWebResults<T>(T Function(_WebResultsNotifier notifier) fn) =>
      select(fn);

  SearchProvider? get searchProvider => read();

  Future<void> _search() async {
    final toaster = this.toaster;
    final db = this.db;
    final promptId = prompt?.id;
    if (promptId == null) return;
    final text = controller.text;
    // We interpret empty text + enter as a "clear" action.
    if (text.isEmpty) {
      webResultsNotifier.value = const IList.empty();
      return;
    }
    final intent = intentNotifier.value;
    final searchProvider = this.searchProvider;
    searchStateNotifier.value = _WebSearchState.loading;
    try {
      switch (intent) {
        case _SearchBarIntent.search:
          if (searchProvider == null) return;
          final results = await searchProvider.search(text);
          if (mounted) webResultsNotifier.value = IList(results);
          return;
        case _SearchBarIntent.genericUrl:
          controller.clear();
          await createWebBlock(text);
          return;
        case _SearchBarIntent.youtubeUrl:
          controller.clear();
          final (_, transcript) =
              await db.createYouTubeBlock(promptId, text) ?? (null, null);
          if (transcript == null) return;
          toaster.show(
            ShadToast(
              title: const Text('YouTube transcript added.'),
              description: Text('"$transcript"', maxLines: 10),
            ),
          );
          return;
      }
    } on Exception catch (e) {
      // Restore the text in case the search / fetch / yt failed.
      if (mounted) controller.text = text;
      toaster.show(
        ShadToast.destructive(
          title: const Text('Error fetching content.'),
          description: Text('$e.'),
        ),
      );
    } finally {
      if (mounted) searchStateNotifier.value = _WebSearchState.idle;
    }
  }
}
