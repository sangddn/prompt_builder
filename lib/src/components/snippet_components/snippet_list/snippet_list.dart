import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../app.dart';
import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../../router/router.dart';
import '../../components.dart';

part 'snippet_list_controller.dart';

class SnippetList extends StatelessWidget {
  const SnippetList({
    required this.controller,
    this.showProjectName = true,
    this.areSnippetsCollapsed = false,
    super.key,
  }) : _useGrid = false;

  const SnippetList.grid({
    this.showProjectName = true,
    required this.controller,
    super.key,
  }) : _useGrid = true,
       areSnippetsCollapsed = false;

  final bool showProjectName;
  final bool areSnippetsCollapsed;
  final SnippetListController controller;
  final bool _useGrid;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_function_declarations_over_variables
    final InfinityItemBuilder<Snippet> builder =
        (context, index, snippet) => SnippetTile(
          key: ValueKey(
            Object.hash(
              snippet,
              controller.sortByNotifier?.value,
              controller.projectIdNotifier?.value,
            ),
          ),
          isCollapsed: areSnippetsCollapsed,
          showProjectName: showProjectName,
          snippet: snippet,
          onDelete: () => controller.onSnippetDeleted(snippet.id),
          onExpanded: () async {
            await context.pushSnippetRoute(id: snippet.id);
            Future.delayed(const Duration(seconds: 1), () async {
              if (!context.mounted) return;
              await controller.reloadSnippet(context, snippet.id);
            });
          },
          onProjectChanged: (project) async {
            final listProject =
                controller.projectIdNotifier?.value ?? const Value.absent();
            // Remove case
            if (project == null) {
              if (!listProject.present) {
                await controller.reloadSnippet(context, snippet.id);
              } else if (listProject.value == snippet.projectId) {
                controller.onSnippetDeleted(snippet.id);
              }
              return;
            }
            // Add case
            if ((!listProject.present) || (listProject.value == project.id)) {
              await controller.reloadSnippet(context, snippet.id);
              return;
            }
            controller.onSnippetDeleted(snippet.id);
            return;
          },
        );
    if (_useGrid) {
      return InfinityAndBeyond.grid(
        controller: controller,
        itemPadding: EdgeInsets.zero,
        maxCrossAxisExtent: 300.0,
        childAspectRatio: 3.5 / 4,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        itemBuilder: builder,
      );
    }
    return InfinityAndBeyond(
      controller: controller,
      padding: k16HPadding,
      shrinkWrap: true,
      itemPadding: k16H4VPadding,
      itemBuilder: builder,
    );
  }
}
