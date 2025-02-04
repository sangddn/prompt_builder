import 'dart:math' show max;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../components.dart';

class ConstrainedCustomScrollView extends StatelessWidget {
  const ConstrainedCustomScrollView({
    super.key,
    this.minCrossAxisPadding = kDefaultMinHorizontalPadding,
    this.maxCrossAxisExtent = kDefaultMaxWidth,
    required this.slivers,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });

  final double maxCrossAxisExtent;
  final double minCrossAxisPadding;
  final List<Widget> slivers;
  final ScrollController? controller;
  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;
  final bool shrinkWrap;
  final Key? center;
  final double anchor;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final maxWidth = maxCrossAxisExtent;
          final horizontalPadding =
              max((availableWidth - maxWidth) / 2, minCrossAxisPadding);
          return Provider<_Constraints>.value(
            value: _Constraints(availableWidth),
            child: CustomScrollView(
              controller: controller,
              scrollDirection: scrollDirection,
              reverse: reverse,
              primary: primary,
              physics: physics,
              scrollBehavior: scrollBehavior,
              shrinkWrap: shrinkWrap,
              center: center,
              anchor: anchor,
              cacheExtent: cacheExtent,
              semanticChildCount: semanticChildCount,
              dragStartBehavior: dragStartBehavior,
              keyboardDismissBehavior: keyboardDismissBehavior,
              restorationId: restorationId,
              clipBehavior: clipBehavior,
              slivers: slivers
                  .map(
                    (e) => e is SliverGap || e is ConstrainedSliver
                        ? e
                        : SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            sliver: e,
                          ),
                  )
                  .toList(),
            ),
          );
        },
      );
}

class _Constraints {
  const _Constraints(this.maxWidth);
  final double maxWidth;
}

class ConstrainedSliver extends StatelessWidget {
  const ConstrainedSliver({
    super.key,
    this.maxCrossAxisExtent = double.infinity,
    this.minCrossAxisPadding = 0.0,
    required this.sliver,
  });

  final double maxCrossAxisExtent;
  final double minCrossAxisPadding;
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    final maxWidth = context.watch<_Constraints>().maxWidth;
    final horizontalPadding =
        max((maxWidth - maxCrossAxisExtent) / 2, minCrossAxisPadding);
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: sliver,
    );
  }
}
