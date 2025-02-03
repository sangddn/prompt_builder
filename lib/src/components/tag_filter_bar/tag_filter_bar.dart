import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/core.dart';
import '../../database/database.dart';
import '../components.dart';

typedef TagFilterNotifier = ValueNotifier<String?>;

class TagFilterBar extends MultiProviderWidget {
  const TagFilterBar({
    required this.notifier,
    required this.type,
    super.key,
  });

  final TagFilterNotifier notifier;
  final TagType type;

  @override
  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider<TagFilterNotifier>.value(value: notifier),
        Provider<TagType>.value(value: type),
      ];

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            const ShadImage.square(LucideIcons.filter, size: 16.0),
            const Gap(8.0),
            const _PopularTagsList(),
            const Gap(8.0),
            ShadButton.ghost(
              onPressed: () => _showAllTags(context),
              size: ShadButtonSize.sm,
              child: const Text('More'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAllTags(BuildContext context) async {
    final selectedTag = await showShadSheet<String>(
      side: ShadSheetSide.right,
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) => Provider<Database>.value(
        value: context.read<Database>(),
        child: _AllTagsSheet(type),
      ),
    );

    if (selectedTag != null && context.mounted) {
      notifier.value = selectedTag;
    }
  }
}

class _PopularTagsList extends StatelessWidget {
  const _PopularTagsList();

  @override
  Widget build(BuildContext context) {
    final selectedTag = context.watch<TagFilterNotifier>().value;

    return StreamProvider<IList<TagCount>>(
      initialData: const IList.empty(),
      create: (context) => context.db
          .streamTagsByFrequency(
            limit: 5,
            type: context.type,
          )
          .map((tags) => IList(tags)),
      builder: (context, snapshot) {
        var list = context.watch<IList<TagCount>>();
        // Make sure selectedTag is in the list
        if (selectedTag != null && !list.any((tag) => tag.tag == selectedTag)) {
          list = list.add(TagCount(tag: selectedTag, count: 0));
        }
        return Row(
          children: [
            for (final tag in list)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ShadButton.ghost(
                  size: ShadButtonSize.sm,
                  icon: selectedTag == tag.tag
                      ? const ShadImage.square(LucideIcons.check, size: 16.0)
                      : null,
                  onPressed: () {
                    final notifier = context.notifier;
                    if (selectedTag == tag.tag) {
                      notifier.value = null;
                    } else {
                      notifier.value = tag.tag;
                    }
                  },
                  child: Row(
                    children: [
                      Text(tag.tag),
                      if (tag.count > 0) ...[
                        const Gap(8.0),
                        Text('${tag.count}', style: context.textTheme.muted),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AllTagsSheet extends StatefulWidget {
  const _AllTagsSheet(this.type);

  final TagType type;

  @override
  State<_AllTagsSheet> createState() => _AllTagsSheetState();
}

class _AllTagsSheetState extends State<_AllTagsSheet> {
  late final _controller = _TagsController(context.db, widget.type);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return ShadSheet(
      title: const Text('All Tags'),
      enterDuration: Effects.veryShortDuration,
      exitDuration: Effects.veryShortDuration,
      isScrollControlled: true,
      scrollable: true,
      constraints: BoxConstraints(
        minWidth: 400,
        maxWidth: 500,
        minHeight: height,
        maxHeight: height,
      ),
      child: CustomScrollView(
        slivers: [
          InfinityAndBeyond<TagCount>(
            controller: _controller,
            itemBuilder: (context, _, tag) => CButton(
              tooltip: 'Filter by ${tag.tag}',
              onTap: () => Navigator.of(context).pop(tag.tag),
              padding: k16H12VPadding,
              child: Row(
                children: [
                  Text(tag.tag, style: context.textTheme.list),
                  const Spacer(),
                  Text('${tag.count}', style: context.textTheme.muted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsController implements InfinityController<TagCount> {
  _TagsController(this.db, this.type);

  final Database db;
  final TagType type;
  @override
  final pagingController = PagingController<int, TagCount>(firstPageKey: 0);

  @override
  void init() {
    pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    pagingController.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final tags = await db.getTagsByFrequency(
        offset: pageKey * 50,
        type: type,
      );
      final isLastPage = tags.length < 50;
      if (isLastPage) {
        pagingController.appendLastPage(tags);
      } else {
        pagingController.appendPage(tags, pageKey + 1);
      }
    } catch (e, s) {
      debugPrint('Error fetching tags: $e. Stack: $s');
      pagingController.error = e;
    }
  }
}

extension _TagFilterBarExtension on BuildContext {
  Database get db => read<Database>();
  TagType get type => read<TagType>();
  TagFilterNotifier get notifier => read<TagFilterNotifier>();
}
