import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

import '../../core/core.dart';

class GrayShimmer extends StatelessWidget {
  const GrayShimmer({
    this.milliseconds = 1000,
    this.enableShimmer = true,
    this.baseOpacity = 0.9,
    this.highlightOpacity = 0.5,
    this.baseShade = 300,
    this.highlightShade = 200,
    required this.child,
    super.key,
  });

  final int milliseconds;
  final bool enableShimmer;
  final Widget child;
  final double baseOpacity;
  final double highlightOpacity;
  final int baseShade;
  final int highlightShade;

  @override
  Widget build(BuildContext context) {
    Widget transition(Widget child, Animation<double> animation) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }

    final child = !enableShimmer
        ? this.child
        : shimmer.Shimmer.fromColors(
            baseColor: Colors.grey[baseShade]!.replaceOpacity(baseOpacity),
            highlightColor:
                Colors.grey[highlightShade]!.replaceOpacity(highlightOpacity),
            period: Duration(milliseconds: milliseconds),
            child: this.child,
          );

    return AnimatedSwitcher(
      duration: Effects.shortDuration,
      transitionBuilder: transition,
      child: child,
    );
  }
}

class ContainerShimmer extends StatelessWidget {
  const ContainerShimmer({
    this.height = 75,
    this.width = double.infinity,
    this.enableShimmer = true,
    this.milliseconds = 1000,
    this.margin = const EdgeInsets.symmetric(
      vertical: 8.0,
    ),
    this.radius = 20.0,
    this.shape,
    super.key,
  });

  final double height;
  final double width;
  final double radius;
  final bool enableShimmer;
  final int milliseconds;
  final EdgeInsetsGeometry margin;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    return GrayShimmer(
      baseOpacity: 0.6,
      highlightOpacity: 0.45,
      enableShimmer: enableShimmer,
      milliseconds: milliseconds,
      child: Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: shape ?? BoxShape.rectangle,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
        ),
      ),
    );
  }
}
