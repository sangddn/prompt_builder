part of '../prompt_page.dart';

class _PPSearchSection extends StatelessWidget {
  const _PPSearchSection();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        PinnedHeaderSliver(
          child: _SearchBar(),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return const ShadInput(
      prefix: ShadImage.square(HugeIcons.strokeRoundedGlobe02, size: 16.0),
      placeholder: Text('Search or paste URL'),
    );
  }
}
