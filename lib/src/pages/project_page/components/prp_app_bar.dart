part of '../project_page.dart';

class _PRPAppBar extends StatelessWidget {
  const _PRPAppBar();

  @override
  Widget build(BuildContext context) => SliverList.list(
    children: const [
      Align(alignment: Alignment.centerLeft, child: _Icon()),
      Gap(24.0),
      _ProjectTitle(),
      Gap(24.0),
      _ProjectNotes(),
    ],
  );
}

class _Icon extends StatelessWidget {
  const _Icon();
  @override
  Widget build(BuildContext context) {
    if (context.select((Project? p) => p == null)) {
      return const SizedBox.square(dimension: 64.0);
    }
    return const ProjectIcon(size: 24.0, padding: k16APadding);
  }
}

class _ProjectTitle extends StatelessWidget {
  const _ProjectTitle();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.h2;
    final project = context.watch<Project?>();
    if (project?.title == null) {
      return GrayShimmer(child: Text('Loading…', style: style));
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400.0),
      child: TextField(
        controller: context.read<_TitleController>(),
        decoration: InputDecoration.collapsed(
          hintText: 'Untitled',
          hintStyle: style.copyWith(
            color: PColors.darkGray.resolveFrom(context),
          ),
        ),
        style: style,
      ),
    );
  }
}

class _ProjectNotes extends StatelessWidget {
  const _ProjectNotes();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.p;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: context.read<_NotesController?>(),
          decoration: InputDecoration(
            hintText: 'Notes',
            hintStyle: style.copyWith(
              color: PColors.textGray.resolveFrom(context),
            ),
            border: InputBorder.none,
          ),
          minLines: 3,
          maxLines: 15,
          style: style,
        ),
      ],
    );
  }
}
