part of '../resources_page.dart';

class _RPTagBar extends StatelessWidget {
  const _RPTagBar();

  @override
  Widget build(BuildContext context) {
    if (context.isLoading()) return const SizedBox.shrink();
    return StateProvider<IList<String>>(
      createInitialValue:
          (context) => context.read<_OrganizedResources>().keys.toIList(),
      child: ValueProvider<TextEditingController>(
        create: (_) => TextEditingController(),
        onNotified: (context, controller) {
          final query = controller?.text ?? '';
          final notifier = context.read<_TagsNotifier>();
          final allTags = context.read<_OrganizedResources>().keys.toIList();
          if (query.isEmpty) {
            notifier.value = allTags;
            return;
          }
          final filteredTags = fuzzySearch(allTags.unlockView, query, 50);
          notifier.value = filteredTags.toIList();
        },
        child: ProxyProvider<TextEditingController, List<String>>(
          update:
              (_, controller, __) =>
                  controller.text
                      .toLowerCase()
                      .split(' ')
                      .where((element) => element.length >= 3)
                      .toList(),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400.0),
              decoration: BoxDecoration(
                color: context.brightSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                boxShadow: mediumShadows(elevation: .5),
              ),
              margin: k8HPadding + const EdgeInsets.only(top: 64.0),
              clipBehavior: Clip.hardEdge,
              child: const Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomScrollView(
                    slivers: [
                      PinnedHeaderSliver(child: _TagSearchField()),
                      _Tags(),
                    ],
                  ),
                  _RPSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TagSearchField extends StatelessWidget {
  const _TagSearchField();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: context.read(),
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(LucideIcons.search, size: 20.0),
            ),
            hintText: 'Search',
            border: InputBorder.none,
            filled: true,
            fillColor: context.brightSurface,
            contentPadding: k16APadding,
          ),
          style: context.textTheme.list,
        ),
        Divider(
          height: 1.0,
          thickness: 1.0,
          color: PColors.gray.resolveFrom(context),
        ),
      ],
    );
  }
}

class _Tags extends StatelessWidget {
  const _Tags();

  @override
  Widget build(BuildContext context) {
    final tagCount = context.select((_TagsNotifier n) => n.value.length);
    return SuperSliverList.builder(
      itemCount: tagCount,
      itemBuilder:
          (context, index) => Builder(
            builder: (context) {
              final tag = context.select(
                (_TagsNotifier n) => n.value.elementAtOrNull(index),
              );
              return tag == null ? const SizedBox.shrink() : _Tag(tag);
            },
          ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.tag);

  final String tag;

  @override
  Widget build(BuildContext context) {
    final count = context.select(
      (_OrganizedResources r) => r[tag]?.length ?? 0,
    );
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: () => context.animateToSection(tag),
        splashColor: Colors.transparent,
        title: HighlightedText(
          text: tag,
          highlights: context.watch(),
          style: context.textTheme.list,
          caseSensitive: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '$count',
          style: context.textTheme.muted,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

typedef _TagsNotifier = ValueNotifier<IList<String>>;
