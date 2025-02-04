part of '../library_page.dart';

class _LPPromptList extends StatelessWidget {
  const _LPPromptList();
  @override
  Widget build(BuildContext context) => PromptGrid(controller: context.read());
}
