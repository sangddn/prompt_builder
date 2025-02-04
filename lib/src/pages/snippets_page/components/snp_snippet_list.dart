part of '../snippets_page.dart';

class _SNPSnippetList extends StatelessWidget {
  const _SNPSnippetList();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SnippetListController>();
    return SnippetList(controller: controller);
  }
}
