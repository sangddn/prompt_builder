part of '../snippet_page.dart';

class _SNPPAppBar extends StatelessWidget {
  const _SNPPAppBar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56.0,
      child: Align(alignment: Alignment.centerLeft, child: MaybeBackButton()),
    );
  }
}
