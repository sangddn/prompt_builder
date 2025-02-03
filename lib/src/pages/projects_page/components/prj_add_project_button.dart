part of '../projects_page.dart';

class _PRJAddProjectButton extends StatelessWidget {
  const _PRJAddProjectButton();

  @override
  Widget build(BuildContext context) {
    return ShadButton.ghost(
      icon: const ShadImage.square(LucideIcons.plus, size: 20.0),
      onPressed: () async {
        final id = await context.db.createProject();
        if (!context.mounted) return;
        context.controller.onProjectAdded(context, id);
        context.pushRoute(ProjectRoute(id: id));
      },
    );
  }
}
