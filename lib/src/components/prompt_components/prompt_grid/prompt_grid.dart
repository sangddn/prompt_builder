import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../../router/router.dart';
import '../../components.dart';

part 'prompt_grid_controller.dart';

class PromptGrid extends StatelessWidget {
  const PromptGrid({
    this.showProjectName = true,
    required this.controller,
    super.key,
  });

  final bool showProjectName;
  final PromptGridController controller;

  @override
  Widget build(BuildContext context) {
    return InfinityAndBeyond.grid(
      controller: controller,
      childAspectRatio: 3.5 / 4,
      maxCrossAxisExtent: 300.0,
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      itemBuilder:
          (context, index, prompt) => PromptTile(
            key: ValueKey(
              Object.hash(
                prompt,
                controller.sortByNotifier?.value,
                controller.projectIdNotifier?.value,
              ),
            ),
            onTap: () async {
              await context.pushPromptRoute(id: prompt.id);
              Future<void>.delayed(const Duration(seconds: 1)).then((_) {
                if (!context.mounted) return;
                controller.reloadPrompt(context, prompt.id);
              });
            },
            onDeleted: () => controller.onPromptDeleted(prompt),
            onDuplicated: controller.onPromptAdded,
            onRemovedFromProject: () async {
              final listProject =
                  controller.projectIdNotifier?.value ?? const Value.absent();
              if (!listProject.present) {
                await controller.reloadPrompt(context, prompt.id);
                return;
              }
              if (listProject.value == prompt.projectId) {
                controller.onPromptDeleted(prompt);
              }
            },
            onAddedToProject: (projectId) async {
              final listProject =
                  controller.projectIdNotifier?.value ?? const Value.absent();
              if ((!listProject.present) || (listProject.value == projectId)) {
                await controller.reloadPrompt(context, prompt.id);
                return;
              }
              controller.onPromptDeleted(prompt);
              return;
            },
            showProjectName: showProjectName,
            prompt: prompt,
          ),
    );
  }
}
