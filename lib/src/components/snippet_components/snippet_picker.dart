import 'package:drift/drift.dart' show Value;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../core/core.dart';
import '../../database/database.dart';
import '../components.dart';

/// Type signature of the notifier that holds the search results.
typedef _SnippetSearchNotifier = ValueNotifier<_SnippetSearchResults>;

/// Type signature of the search results.
typedef _SnippetSearchResults = IList<Snippet>;

enum _SnippetSearchState { idle, searching }

final class _SnippetSearchScopeNotifier extends ValueNotifier<(bool, bool)> {
  _SnippetSearchScopeNotifier(int? projectId)
    : super((projectId != null, projectId != null));

  bool get hasProject => value.$1;
  bool get searchProjectOnly => value.$2;
}

class SnippetPicker extends StatelessWidget {
  const SnippetPicker({
    this.projectId,
    required this.database,
    required this.onSelected,
    super.key,
  });

  final Database database;
  final ValueChanged<Snippet> onSelected;
  final int? projectId;

  Future<void> _onTextChanged(
    BuildContext context,
    TextEditingController? controller,
  ) async {
    if (controller?.text case final text?) {
      final stateNotifier = context.read<ValueNotifier<_SnippetSearchState>>();
      final scopeNotifier = context.read<_SnippetSearchScopeNotifier>();
      final notifier = context.read<_SnippetSearchNotifier>();
      stateNotifier.value = _SnippetSearchState.searching;
      final results =
          (await database.querySnippets(
            searchQuery: text,
            limit: 20,
            projectId:
                scopeNotifier.searchProjectOnly
                    ? Value(projectId)
                    : const Value.absent(),
          )).toIList();
      if (!context.mounted) return;
      stateNotifier.value = _SnippetSearchState.idle;
      if (text == controller?.text) {
        notifier.value = results;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StateProvider<_SnippetSearchResults>(
      createInitialValue: (_) => const IList.empty(),
      child: StateProvider<_SnippetSearchState>(
        createInitialValue: (_) => _SnippetSearchState.idle,
        child: MultiProvider(
          providers: [
            Provider<ValueChanged<Snippet>>.value(value: onSelected),
            ValueProvider<_SnippetSearchScopeNotifier>(
              create: (_) => _SnippetSearchScopeNotifier(projectId),
            ),
            ValueProvider<TextEditingController>(
              create: (context) {
                final controller = TextEditingController();
                // Triggers searching immediately
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _onTextChanged(context, controller);
                });
                context.read<_SnippetSearchScopeNotifier>().addListener(() {
                  _onTextChanged(context, controller);
                });
                return controller;
              },
              onNotified: _onTextChanged,
            ),
          ],
          builder:
              (context, child) =>
                  ProxyProvider<TextEditingController, List<String>>(
                    update:
                        (_, controller, _) =>
                            controller.text
                                .toLowerCase()
                                .split(' ')
                                .where((element) => element.length >= 3)
                                .toList(),
                    child: child,
                  ),
          child: SizedBox(
            width: 400.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 500.0),
              child: const CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  PinnedHeaderSliver(
                    child: Column(
                      children: [
                        _SearchField(),
                        Divider(height: 1.0, thickness: 1.0),
                      ],
                    ),
                  ),
                  SliverGap(8.0),
                  SliverPadding(padding: k12HPadding, sliver: _ResultList()),
                  SliverGap(24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(7.5),
        topRight: Radius.circular(7.5),
      ),
      child: TextField(
        controller: context.read(),
        autofocus: true,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Builder(
              builder: (context) {
                final isLoading =
                    context.watch<_SnippetSearchState>() ==
                    _SnippetSearchState.searching;
                return GrayShimmer(
                  enableShimmer: isLoading,
                  child: const Icon(LucideIcons.search, size: 20.0),
                );
              },
            ),
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: _ScopeToggler(),
          ),
          hintText: 'Search snippets…',
          filled: true,
          fillColor: context.colorScheme.popover,
          border: InputBorder.none,
          contentPadding: k12VPadding,
        ),
        style: context.textTheme.list,
      ),
    );
  }
}

class _ScopeToggler extends StatelessWidget {
  const _ScopeToggler();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<_SnippetSearchScopeNotifier>();
    if (!notifier.hasProject) return const SizedBox();
    return CupertinoSlidingSegmentedControl<bool>(
      groupValue: notifier.searchProjectOnly,
      onValueChanged: (value) {
        if (value == null) return;
        notifier.value = (notifier.hasProject, value);
      },
      proportionalWidth: true,
      children: const {true: Text('Project'), false: Text('All')},
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList();

  @override
  Widget build(BuildContext context) {
    final results = context.watch<_SnippetSearchNotifier>().value;
    return SuperSliverList.list(
      children:
          results
              .indexedExpand(
                (i, info) => [
                  _SnippetSearchResult(info),
                  if (i < results.length - 1) const Gap(6.0),
                ],
              )
              .toList(),
    );
  }
}

class _SnippetSearchResult extends StatelessWidget {
  const _SnippetSearchResult(this.snippet);

  final Snippet snippet;

  @override
  Widget build(BuildContext context) {
    final highlights = context.watch<List<String>>();
    final title = snippet.title;
    final showProjectName =
        snippet.projectId != null &&
        !context.watch<_SnippetSearchScopeNotifier>().searchProjectOnly;

    return HoverTapBuilder(
      builder: (context, isHovered) {
        void select() {
          context.read<ValueChanged<Snippet>>()(snippet);
          context.read<Database>().recordSnippetUsage(snippet.id);
        }

        final trailing =
            isHovered
                ? ShadBadge(onPressed: select, child: const Text('Add'))
                : ShadBadge.secondary(
                  onPressed: select,
                  child: const Text('Add'),
                );
        return CButton(
          tooltip: null,
          onTap: select,
          padding: k16H12VPadding,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HighlightedText(
                      text: title,
                      highlights: highlights,
                      caseSensitive: false,
                    ),
                    if (showProjectName) ...[
                      const Gap(4.0),
                      ProjectName(snippet.projectId!),
                    ],
                    if (snippet.content.isNotEmpty) ...[
                      const Gap(4.0),
                      HighlightedText(
                        text: snippet.content,
                        maxLines: 2,
                        highlights: highlights,
                        caseSensitive: false,
                        style: context.textTheme.muted,
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(8.0),
              trailing,
            ],
          ),
        );
      },
    );
  }
}
