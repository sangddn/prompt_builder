import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' show Value;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../app.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../components.dart';

/// Picks a project from the database.
///
/// If [currentProject] is provided, the picker will show the current project
/// as selected.
///
/// Returns `Value.absent()` if the existing project is deleted, `Value(project)`
/// if the user picks a new project, or `null` if the dialog is dismissed.
Future<Value<Project>?> pickProject(
  BuildContext context, {
  int? currentProject,
}) => showPDialog<Value<Project>?>(
  context: context,
  barrierColor: Colors.transparent,
  builder:
      (_) => Provider<Database>.value(
        value: context.db,
        child: ProjectPicker(currentProject: currentProject),
      ),
);

class ProjectPicker extends StatelessWidget {
  const ProjectPicker({this.currentProject, super.key});

  final int? currentProject;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: MultiProvider(
        providers: [
          Provider<int?>.value(value: currentProject),
          ValueProvider<ValueNotifier<_ProjectSearchState>>(
            create: (_) => ValueNotifier(_ProjectSearchState.idle),
          ),
          ValueProvider<TextEditingController>(
            create: (_) => TextEditingController(),
          ),
          ListenableProvider(create: (_) => FocusNode()),
          ValueProvider<_ResultsNotifier>(
            create: (_) => _ResultsNotifier(const IList.empty()),
          ),
          ProxyProvider<TextEditingController, List<String>>(
            lazy: false,
            update: (context, controller, __) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => context._search(),
              );
              return controller.text
                  .toLowerCase()
                  .split(' ')
                  .where((element) => element.length >= 3)
                  .toList();
            },
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
              child: CustomScrollView(
                shrinkWrap: true,
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
                  SliverPadding(padding: k12HPadding, sliver: _ProjectList()),
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
          padding: k16HPadding,
          child: Builder(
            builder: (context) {
              final isLoading = context.isSearching();
              return GrayShimmer(
                enableShimmer: isLoading,
                child: const Icon(LucideIcons.folderSearch2, size: 20.0),
              );
            },
          ),
        ),
        hintText: 'Search Projects',
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

// -----------------------------------------------------------------------------
// Project List
// -----------------------------------------------------------------------------

class _ProjectList extends StatelessWidget {
  const _ProjectList();

  @override
  Widget build(BuildContext context) {
    final count = context.select((_ResultsNotifier n) => n.value.length);
    return SuperSliverList.builder(
      itemCount: count,
      itemBuilder:
          (context, index) => Builder(
            builder: (context) {
              final result = context.selectResults(
                (n) => n.value.elementAtOrNull(index),
              );
              if (result == null) return const SizedBox.shrink();
              return _ProjectResult(result);
            },
          ),
    );
  }
}

class _ProjectResult extends StatelessWidget {
  const _ProjectResult(this.project);

  final Project project;

  @override
  Widget build(BuildContext context) {
    final highlights = context.watch<List<String>>();
    final title = project.title;
    final currentProject = context.watchCurrentProject();
    final isCurrent = currentProject == project.id;

    return HoverBuilder(
      builder: (context, isHovered) {
        void selectOrDeselect() =>
            isCurrent
                ? context.maybePop(const Value<Project>.absent())
                : context.maybePop(Value(project));
        final text = isCurrent ? const Text('Remove') : const Text('Move');
        final trailing =
            isHovered
                ? ShadBadge(onPressed: selectOrDeselect, child: text)
                : ShadBadge.secondary(onPressed: selectOrDeselect, child: text);
        return CButton(
          tooltip: null,
          onTap: selectOrDeselect,
          padding: k16H12VPadding,
          child: Row(
            children: [
              Provider<Project>.value(
                value: project,
                child: const ProjectIcon(),
              ),
              const Gap(8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HighlightedText(
                      text: title,
                      highlights: highlights,
                      caseSensitive: false,
                    ),
                    if (project.notes.isNotEmpty) ...[
                      const Gap(4.0),
                      HighlightedText(
                        text: project.notes,
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

// -----------------------------------------------------------------------------
// Typedefs and Extensions
// -----------------------------------------------------------------------------

typedef _Results = IList<Project>;
typedef _ResultsNotifier = ValueNotifier<_Results>;

enum _ProjectSearchState { idle, loading }

extension _ProjectSearchSectionExtension on BuildContext {
  ValueNotifier<_ProjectSearchState> get searchStateNotifier => read();
  _ProjectSearchState watchSearchState() =>
      watch<ValueNotifier<_ProjectSearchState>>().value;
  bool isSearching() => watchSearchState() == _ProjectSearchState.loading;

  TextEditingController get controller => read();

  _ResultsNotifier get resultsNotifier => read();
  T selectResults<T>(T Function(_ResultsNotifier notifier) fn) => select(fn);

  int? watchCurrentProject() => watch();

  Future<void> _search() async {
    final toaster = this.toaster;
    final db = this.db;
    final text = controller.text;
    searchStateNotifier.value = _ProjectSearchState.loading;
    try {
      final results = await db.queryProjects(
        searchQuery: text,
        sortBy: ProjectSortBy.updatedAt,
      );
      // Only update the results if the text hasn't changed.
      if (mounted && text == controller.text) {
        resultsNotifier.value = IList(results);
      }
    } on Exception catch (e) {
      toaster.show(
        ShadToast.destructive(
          title: const Text('Error searching projects.'),
          description: Text('$e.'),
        ),
      );
    } finally {
      if (mounted && text == controller.text) {
        searchStateNotifier.value = _ProjectSearchState.idle;
      }
    }
  }
}
