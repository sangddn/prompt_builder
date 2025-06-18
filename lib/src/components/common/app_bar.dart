import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/core.dart';
import '../components.dart';

enum _AppBarSize { small, medium, large }

class AppBarDefaults {
  const AppBarDefaults({this.shouldShow = true});

  final bool shouldShow;
}

class PAppBar extends StatefulWidget {
  const PAppBar({
    this.leading,
    required this.title,
    this.decoration,
    this.background,
    this.upperActions = const [],
    this.actions = const [],
    this.bottom,
    this.backgroundColor = Colors.transparent,
    this.toolbarOpacity = 0.9,
    this.scrolledUnderOpacity,
    super.key,
  }) : _size = _AppBarSize.medium;

  const PAppBar.small({
    this.leading,
    required this.title,
    this.decoration,
    this.background,
    this.upperActions = const [],
    this.actions = const [],
    this.bottom,
    this.backgroundColor = Colors.transparent,
    this.toolbarOpacity = 0.9,
    this.scrolledUnderOpacity,
    super.key,
  }) : _size = _AppBarSize.small;

  const PAppBar.large({
    this.leading,
    required this.title,
    this.decoration,
    this.background,
    this.upperActions = const [],
    this.actions = const [],
    this.bottom,
    this.backgroundColor = Colors.transparent,
    this.toolbarOpacity = 0.9,
    this.scrolledUnderOpacity,
    super.key,
  }) : _size = _AppBarSize.large;

  final BoxDecoration? decoration;
  final Widget? leading, title;
  final Color? backgroundColor;
  final Widget? background;
  final List<Widget> upperActions;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final _AppBarSize _size;

  /// The opacity of the toolbar. Defaults to 0.9.
  ///
  /// This is only used on wide and extra wide screens.
  ///
  final double toolbarOpacity;

  /// The opacity of the toolbar when scrolled under. Defaults to [toolbarOpacity].
  ///
  /// This is only used on wide and extra wide screens.
  ///
  final double? scrolledUnderOpacity;

  @override
  State<PAppBar> createState() => _PAppBarState();
}

class _PAppBarState extends State<PAppBar> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  double _extentBefore = 0.0;
  bool get _scrolledUnder => false;

  static const _altTitleThreshold = 48.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = null;
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    final bool isRelevantNotification =
        notification is ScrollUpdateNotification ||
        notification is OverscrollNotification;
    if (isRelevantNotification && notification.depth == 0) {
      final bool oldScrolledUnder = _scrolledUnder;
      final double oldExtentBefore = _extentBefore;
      _extentBefore = notification.metrics.extentBefore;

      if ((_extentBefore != oldExtentBefore &&
              _extentBefore >= 0.0 &&
              _extentBefore <= _altTitleThreshold) ||
          (_scrolledUnder != oldScrolledUnder)) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final title = widget.title;
    final dividerColor = theme.resolveColor(
      Colors.black.replaceOpacity(.05),
      Colors.grey.shade(.8),
    );

    // A value of 0.0 means the app bar is fully expanded, and a value of 1.0
    // means the app bar is fully collapsed.
    final collapseValue = (_extentBefore / _altTitleThreshold).clamp(0.0, 1.0);
    final pageTitleAndActions =
        title == null && widget.actions.isEmpty
            ? null
            : Row(
              children: [
                if (title != null)
                  Expanded(
                    child: Opacity(
                      opacity: ((0.8 - collapseValue) / 0.8).clamp(0.0, 1.0),
                      child: DefaultTextStyle(
                        style: theme.textTheme.h3,
                        child: title,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                ...widget.actions.addBetween(const Gap(8.0)),
              ],
            );

    final upperRightActions =
        widget.upperActions.isEmpty
            ? const SizedBox.shrink()
            : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(16.0),
                ...widget.upperActions.addBetween(const Gap(8.0)),
                const Gap(16.0),
              ],
            );

    final flexibleSpace = FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(
        right: 16.0,
        left: 16.0,
        bottom: widget.bottom != null ? 56.0 : 8.0,
      ),
      background: widget.backgroundColor != null ? null : widget.background,
      stretchModes: const [StretchMode.fadeTitle],
      title: pageTitleAndActions,
    );

    final effectiveLeading = widget.leading ?? const MaybeBackButton();

    final appBar =
        widget._size == _AppBarSize.small
            ? SliverAppBar(
              backgroundColor: widget.backgroundColor,
              scrolledUnderElevation: 0.0,
              stretch: true,
              automaticallyImplyLeading: false,
              flexibleSpace: flexibleSpace,
              actions: [upperRightActions],
              leading: effectiveLeading,
              bottom: widget.bottom,
            )
            : widget._size == _AppBarSize.medium
            ? SliverAppBar.medium(
              backgroundColor: widget.backgroundColor,
              scrolledUnderElevation: 0.0,
              stretch: true,
              automaticallyImplyLeading: false,
              flexibleSpace: flexibleSpace,
              actions: [upperRightActions],
              leading: effectiveLeading,
              bottom: widget.bottom,
            )
            : SliverAppBar.large(
              backgroundColor: widget.backgroundColor,
              scrolledUnderElevation: 0.0,
              stretch: true,
              automaticallyImplyLeading: false,
              flexibleSpace: flexibleSpace,
              actions: [upperRightActions],
              leading: effectiveLeading,
              bottom: widget.bottom,
            );

    return SliverMainAxisGroup(
      slivers: [
        if (widget.decoration case final decor?)
          DecoratedSliver(decoration: decor, sliver: appBar)
        else
          appBar,
        PinnedHeaderSliver(
          child: Container(
            color: dividerColor.withOpacityFactor(collapseValue),
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class ModalAppBar extends StatelessWidget {
  const ModalAppBar({
    this.backgroundColor,
    this.title,
    this.actions = const [],
    this.closeInterceptor,
    this.pinned = true,
    this.floating = true,
    this.snap = true,
    super.key,
  });

  final bool pinned;
  final bool floating;
  final bool snap;
  final Color? backgroundColor;
  final Widget? title;
  final List<Widget> actions;

  /// If this returns true, the modal will close.
  /// If this returns false, the modal will not close.
  ///
  final FutureOr<bool> Function(BuildContext context)? closeInterceptor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: title,
      centerTitle: true,
      titleTextStyle: context.textTheme.large.addWeight(1),
      pinned: pinned,
      floating: floating,
      snap: snap,
      backgroundColor: backgroundColor ?? theme.colorScheme.background,
      scrolledUnderElevation: 0.0,
      leading: MaybeBackButton(
        size: 20.0,
        forceUseCloseButton: true,
        closeInterceptor: closeInterceptor,
      ),
      actions: actions,
    );
  }
}

class MaybeBackButton extends StatefulWidget {
  const MaybeBackButton({
    this.closeInterceptor,
    this.forceUseCloseButton = false,
    this.size,
    super.key,
  });

  /// If this returns true, the modal will close.
  /// If this returns false, the modal will not close.
  ///
  final FutureOr<bool> Function(BuildContext context)? closeInterceptor;
  final bool forceUseCloseButton;
  final double? size;

  static bool willShow(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    return parentRoute?.impliesAppBarDismissal ?? false;
  }

  static bool useCloseButton(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    return parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
  }

  @override
  State<MaybeBackButton> createState() => _MaybeBackButtonState();
}

class _MaybeBackButtonState extends State<MaybeBackButton> {
  Future<void> _close(BuildContext context) async {
    final shouldClose =
        widget.closeInterceptor == null ||
        await widget.closeInterceptor!(context);
    if (!context.mounted) {
      return;
    }
    if (shouldClose) {
      context.router.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final useCloseButton =
        widget.forceUseCloseButton || MaybeBackButton.useCloseButton(context);
    if (MaybeBackButton.willShow(context)) {
      return AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: CButton(
            tooltip:
                useCloseButton
                    ? localizations.closeButtonTooltip
                    : localizations.backButtonTooltip,
            cornerRadius: 12.0,
            onTap: () => _close(context),
            child: Icon(
              useCloseButton ? CupertinoIcons.clear : CupertinoIcons.back,
              size: widget.size,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
