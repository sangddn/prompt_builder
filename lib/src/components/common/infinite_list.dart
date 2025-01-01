import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../core/core.dart';

/// A widget that displays a grid of items that can be scrolled infinitely.
///
/// This widget is a wrapper around the [PagedListView], [PagedMasonryGridView],
/// [PagedSliverGrid], and [PagedSliverList] widgets from the
/// [infinite_scroll_pagination](https://pub.dev/packages/infinite_scroll_pagination)
/// package. It provides a simple way to display a grid of items that can be
/// scrolled infinitely and loaded on demand.
///
class InfinityAndBeyond<T> extends StatefulWidget {
  const InfinityAndBeyond({
    this.padding = k8HPadding,
    this.itemPadding = const EdgeInsets.all(8.0),
    this.buildEmpty = _defaultBuildEmpty,
    this.buildError = _defaultBuildError,
    this.shrinkWrap = false,
    this.separatorBuilder,
    this.progressBuilder,
    this.listController,
    this.extentEstimation,
    this.extentPrecalculationPolicy,
    required this.itemBuilder,
    required this.controller,
    super.key,
  });

  final EdgeInsetsGeometry itemPadding, padding;
  final WidgetBuilder buildEmpty, buildError;
  final bool shrinkWrap;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final WidgetBuilder? progressBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final InfinityController<T> controller;
  final ListController? listController;
  final ExtentEstimationProvider? extentEstimation;
  final ExtentPrecalculationPolicy? extentPrecalculationPolicy;

  @override
  State<InfinityAndBeyond<T>> createState() => _InfinityAndBeyondState<T>();
}

class _InfinityAndBeyondState<T> extends State<InfinityAndBeyond<T>> {
  late final _controller = widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.init();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemPadding = widget.itemPadding;
    final builderDelegate = PagedChildBuilderDelegate<T>(
      animateTransitions: true,
      itemBuilder: (context, item, index) => Padding(
        padding: itemPadding,
        child: widget.itemBuilder(context, index, item),
      ),
      firstPageErrorIndicatorBuilder: widget.buildError,
      newPageErrorIndicatorBuilder: widget.buildError,
      newPageProgressIndicatorBuilder: _buildProgress,
      firstPageProgressIndicatorBuilder: _buildProgress,
      noItemsFoundIndicatorBuilder: widget.buildEmpty,
      noMoreItemsIndicatorBuilder: _buildNoMore,
    );

    if (widget.separatorBuilder case final separatorBuilder?) {
      return SliverSafeArea(
        top: false,
        bottom: false,
        sliver: EfficientPagedSliverList<int, T>.separated(
          pagingController: _controller.pagingController,
          builderDelegate: builderDelegate,
          shrinkWrapFirstPageIndicators: widget.shrinkWrap,
          extentEstimation: widget.extentEstimation,
          extentPrecalculationPolicy: widget.extentPrecalculationPolicy,
          listController: widget.listController,
          separatorBuilder: separatorBuilder,
        ),
      );
    }
    return SliverSafeArea(
      top: false,
      bottom: false,
      sliver: EfficientPagedSliverList<int, T>(
        pagingController: _controller.pagingController,
        builderDelegate: builderDelegate,
        shrinkWrapFirstPageIndicators: widget.shrinkWrap,
        extentEstimation: widget.extentEstimation,
        extentPrecalculationPolicy: widget.extentPrecalculationPolicy,
        listController: widget.listController,
      ),
    );
  }

  Widget _buildProgress(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: widget.progressBuilder?.call(context) ??
            const SizedBox(
              width: 80.0,
              height: 200.0,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
      );

  Widget _buildNoMore(BuildContext context) => const SizedBox.shrink();
}

abstract interface class InfinityController<T> {
  PagingController<int, T> get pagingController;
  void init();
  void dispose();
}

const _defaultEmptyWidget = Text('Nothing here yet.');
const _defaultErrorWidget = Text('Failed to load the requested data.');

Widget _defaultBuildEmpty(BuildContext context) => Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: broadShadowsCard(context),
        padding: k16H8VPadding,
        margin: k16H8VPadding,
        child: _defaultEmptyWidget,
      ),
    );

Widget _defaultBuildError(BuildContext context) => Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: broadShadowsCard(context),
        padding: k16H8VPadding,
        margin: k16H8VPadding,
        child: const Row(
          children: [
            Icon(
              HugeIcons.strokeRoundedWifiError01,
              size: 20.0,
            ),
            Gap(16.0),
            Expanded(child: _defaultErrorWidget),
          ],
        ),
      ),
    );

// -----------------------------------------------------------------------------
// EFFICIENT PAGED LAYOUTS
// Based on the original implementation of the infinite_scroll_pagination
// package, but make use of the widgets from the super_sliver_list package for
// better performance.
// -----------------------------------------------------------------------------

/// A [SliverList] with pagination capabilities.
///
/// To include separators, use [PagedSliverList.separated].
///
/// Similar to [EfficientPagedListView] but needs to be wrapped by a
/// [CustomScrollView] when added to the screen.
/// Useful for combining multiple scrollable pieces in your UI or if you need
/// to add some widgets preceding or following your paged list.
class EfficientPagedSliverList<PageKeyType, ItemType> extends StatelessWidget {
  const EfficientPagedSliverList({
    required this.pagingController,
    required this.builderDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback,
    this.shrinkWrapFirstPageIndicators = false,
    this.extentEstimation,
    this.listController,
    this.extentPrecalculationPolicy,
    super.key,
  }) : _separatorBuilder = null;

  const EfficientPagedSliverList.separated({
    required this.pagingController,
    required this.builderDelegate,
    required IndexedWidgetBuilder separatorBuilder,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback,
    this.shrinkWrapFirstPageIndicators = false,
    this.extentEstimation,
    this.listController,
    this.extentPrecalculationPolicy,
    super.key,
  }) : _separatorBuilder = separatorBuilder;

  /// Matches [PagedLayoutBuilder.pagingController].
  final PagingController<PageKeyType, ItemType> pagingController;

  /// Matches [PagedLayoutBuilder.builderDelegate].
  final PagedChildBuilderDelegate<ItemType> builderDelegate;

  /// The builder for list item separators, just like in [ListView.separated].
  final IndexedWidgetBuilder? _separatorBuilder;

  /// Matches [SliverChildBuilderDelegate.addAutomaticKeepAlives].
  final bool addAutomaticKeepAlives;

  /// Matches [SliverChildBuilderDelegate.addRepaintBoundaries].
  final bool addRepaintBoundaries;

  /// Matches [SliverChildBuilderDelegate.addSemanticIndexes].
  final bool addSemanticIndexes;

  /// Matches [SliverChildBuilderDelegate.semanticIndexCallback].
  final SemanticIndexCallback? semanticIndexCallback;

  /// Matches [PagedLayoutBuilder.shrinkWrapFirstPageIndicators].
  final bool shrinkWrapFirstPageIndicators;

  /// Matches [SuperSliverList.extentEstimation].
  final ExtentEstimationProvider? extentEstimation;

  /// Matches [SuperSliverList.listController].
  final ListController? listController;

  /// Matches [SuperSliverList.extentPrecalculationPolicy]
  final ExtentPrecalculationPolicy? extentPrecalculationPolicy;

  @override
  Widget build(BuildContext context) =>
      PagedLayoutBuilder<PageKeyType, ItemType>(
        layoutProtocol: PagedLayoutProtocol.sliver,
        pagingController: pagingController,
        builderDelegate: builderDelegate,
        completedListingBuilder: (
          context,
          itemBuilder,
          itemCount,
          noMoreItemsIndicatorBuilder,
        ) =>
            _buildSliverList(
          itemBuilder,
          itemCount,
          statusIndicatorBuilder: noMoreItemsIndicatorBuilder,
          extentEstimation: extentEstimation,
          listController: listController,
          extentPrecalculationPolicy: extentPrecalculationPolicy,
        ),
        loadingListingBuilder: (
          context,
          itemBuilder,
          itemCount,
          progressIndicatorBuilder,
        ) =>
            _buildSliverList(
          itemBuilder,
          itemCount,
          statusIndicatorBuilder: progressIndicatorBuilder,
          extentEstimation: extentEstimation,
          listController: listController,
          extentPrecalculationPolicy: extentPrecalculationPolicy,
        ),
        errorListingBuilder: (
          context,
          itemBuilder,
          itemCount,
          errorIndicatorBuilder,
        ) =>
            _buildSliverList(
          itemBuilder,
          itemCount,
          statusIndicatorBuilder: errorIndicatorBuilder,
          extentEstimation: extentEstimation,
          listController: listController,
          extentPrecalculationPolicy: extentPrecalculationPolicy,
        ),
        shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
      );

  SliverMultiBoxAdaptorWidget _buildSliverList(
    IndexedWidgetBuilder itemBuilder,
    int itemCount, {
    WidgetBuilder? statusIndicatorBuilder,
    ExtentEstimationProvider? extentEstimation,
    ListController? listController,
    ExtentPrecalculationPolicy? extentPrecalculationPolicy,
  }) {
    final separatorBuilder = _separatorBuilder;
    final effectiveItemCount =
        statusIndicatorBuilder == null ? itemCount : itemCount + 1;
    final effectiveItemBuilder = statusIndicatorBuilder == null
        ? itemBuilder
        : (BuildContext context, int index) {
            if (index == itemCount) {
              return statusIndicatorBuilder(context);
            }
            return itemBuilder(context, index);
          };

    return separatorBuilder != null
        ? SuperSliverList.separated(
            extentEstimation: extentEstimation,
            extentPrecalculationPolicy: extentPrecalculationPolicy,
            listController: listController,
            itemBuilder: effectiveItemBuilder,
            separatorBuilder: separatorBuilder,
            itemCount: effectiveItemCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
          )
        : SuperSliverList.builder(
            extentEstimation: extentEstimation,
            extentPrecalculationPolicy: extentPrecalculationPolicy,
            listController: listController,
            itemBuilder: effectiveItemBuilder,
            itemCount: effectiveItemCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
          );
  }
}
