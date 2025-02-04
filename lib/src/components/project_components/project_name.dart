import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../router/router.dart';

class ProjectName extends StatelessWidget {
  const ProjectName(this.projectId, {super.key});

  final int projectId;

  @override
  Widget build(BuildContext context) {
    return FutureProvider<Project?>(
      initialData: null,
      create: (context) => context.db.getProject(projectId),
      catchError: (context, error) {
        debugPrint(error.toString());
        return null;
      },
      builder: (context, _) {
        final project = context.watch<Project?>();
        if (project == null) return const SizedBox.shrink();
        return Text.rich(
          TextSpan(
            text: 'In ',
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: () => context.pushProjectRoute(id: projectId),
                  child: Text(
                    project.title,
                    style: context.textTheme.muted.copyWith(
                      color: context.colorScheme.foreground,
                      decoration: TextDecoration.underline,
                      decorationColor: PColors.textGray.resolveFrom(context),
                      decorationThickness: .5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          style: context.textTheme.muted,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
