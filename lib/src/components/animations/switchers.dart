// FlipSwitcher, ZoomSwitcher, and TranslationSwitcher are based on
// the package [AnimatedSwitcherPlus](https://pub.dev/packages/animated_switcher_plus).
// This file adds "size-fade" and blur effect transitions and additional switcher
// widgets.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../core/ui/ui.dart';

const _curveIn = Curves.easeOutQuad;
const _curveOut = Curves.easeInQuad;

/// Switcher with flip transition
class FlipSwitcher extends AnimatedSwitcher {
  /// Switcher with flip transition around x axis
  FlipSwitcher.flipX({
    required super.duration,
    super.reverseDuration,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    super.child,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          switchInCurve: switchInCurve ?? _curveIn,
          switchOutCurve: switchOutCurve ?? _curveOut,
          transitionBuilder: fadeTransitionBuilder(false),
        );

  /// Switcher with flip transition around y axis
  FlipSwitcher.flipY({
    required super.duration,
    super.reverseDuration,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    super.child,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          switchInCurve: switchInCurve ?? _curveIn,
          switchOutCurve: switchOutCurve ?? _curveOut,
          transitionBuilder: fadeTransitionBuilder(true),
        );
}

AnimatedSwitcherTransitionBuilder fadeTransitionBuilder(bool isYAxis) =>
    (final child, final animation) => _FlipTransition(
          rotate: animation,
          isYAxis: isYAxis,
          child: child,
        );

class _FlipTransition extends AnimatedWidget {
  const _FlipTransition({
    required Animation<double> rotate,
    required this.isYAxis,
    this.child,
  }) : super(listenable: rotate);

  final bool isYAxis;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (rotate.value < 0.5) {
      return SizedBox.shrink(child: child);
    }
    final transform = Matrix4.identity()..setEntry(3, 2, 0.001);

    if (isYAxis) {
      transform.rotateY((1 - rotate.value) * math.pi);
    } else {
      transform.rotateX((1 - rotate.value) * math.pi);
    }

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: child,
    );
  }

  Animation<double> get rotate => listenable as Animation<double>;
}

const _tCurveIn = Curves.easeInOut;
const _tCurveOut = Curves.easeInOut;

/// Switcher with translation transition
class TranslationSwitcher extends AnimatedSwitcher {
  /// Switcher with translation transition toward left
  TranslationSwitcher.left({
    super.duration = Effects.shortDuration,
    double offset = 1.0,
    super.reverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    bool enableFade = true,
    super.key,
  }) : super(
          switchInCurve: switchInCurve ?? _tCurveIn,
          switchOutCurve: switchOutCurve ?? _tCurveOut,
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder:
              translationTransitionBuilder(Offset(offset, 0), enableFade),
        );

  /// Switcher with translation transition toward right
  TranslationSwitcher.right({
    super.duration = Effects.shortDuration,
    double offset = 1.0,
    super.reverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    bool enableFade = true,
    super.key,
  }) : super(
          switchInCurve: switchInCurve ?? _tCurveIn,
          switchOutCurve: switchOutCurve ?? _tCurveOut,
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder:
              translationTransitionBuilder(Offset(-offset, 0), enableFade),
        );

  /// Switcher with translation transition toward top
  TranslationSwitcher.top({
    super.duration = Effects.shortDuration,
    double offset = 1.0,
    super.reverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    bool enableFade = true,
    super.key,
  }) : super(
          switchInCurve: switchInCurve ?? _tCurveIn,
          switchOutCurve: switchOutCurve ?? _tCurveOut,
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder:
              translationTransitionBuilder(Offset(0, offset), enableFade),
        );

  /// Switcher with translation transition toward bottom
  TranslationSwitcher.bottom({
    super.duration = Effects.shortDuration,
    double offset = 1.0,
    super.reverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    bool enableFade = true,
    super.key,
  }) : super(
          switchInCurve: switchInCurve ?? _tCurveIn,
          switchOutCurve: switchOutCurve ?? _tCurveOut,
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder:
              translationTransitionBuilder(Offset(0, -offset), enableFade),
        );
}

AnimatedSwitcherTransitionBuilder translationTransitionBuilder(
  Offset offset,
  bool enableFade,
) =>
    (final child, final animation) {
      final bool isReversed = animation.status.isCompletedOrReversed;

      return SlideTransition(
        position: Tween<Offset>(
          begin: isReversed ? offset.scale(-1, -1) : offset,
          end: Offset.zero,
        ).animate(animation),
        child: enableFade
            ? FadeTransition(
                opacity: animation,
                child: child,
              )
            : child,
      );
    };

const _zCurveIn = Curves.easeIn;
const _zCurveOut = Curves.easeOut;

/// Switcher with zoom transition
class ZoomSwitcher extends AnimatedSwitcher {
  /// Switcher with zoom in transition
  ZoomSwitcher.zoomIn({
    super.duration = Effects.shortDuration,
    super.reverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    double scaleInFactor = 0.88,
    double scaleOutFactor = 1.14,
    super.child,
    super.key,
  }) : super(
          switchInCurve: switchInCurve ?? _zCurveIn,
          switchOutCurve: switchOutCurve ?? _zCurveOut,
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder:
              zoomTransitionBuilder(scaleInFactor, scaleOutFactor),
        );

  /// Switcher with zoom out transition
  ZoomSwitcher.zoomOut({
    super.duration = Effects.shortDuration,
    super.reverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    double scaleInFactor = 1.14,
    double scaleOutFactor = 0.88,
    super.child,
    super.key,
  }) : super(
          switchInCurve: switchInCurve ?? _zCurveIn,
          switchOutCurve: switchOutCurve ?? _zCurveOut,
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder:
              zoomTransitionBuilder(scaleInFactor, scaleOutFactor),
        );
}

class SizeFadeSwitcher extends StatelessWidget {
  const SizeFadeSwitcher({
    this.axis = Axis.vertical,
    this.axisAlignment = -1.0,
    this.reverseDuration,
    this.switchInCurve = Curves.easeOut,
    this.switchOutCurve = Curves.easeIn,
    this.layoutBuilder,
    this.duration = Effects.mediumDuration,
    required this.child,
    super.key,
  });

  final Widget child;
  final Axis axis;
  final double axisAlignment;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve switchInCurve, switchOutCurve;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            axis: axis,
            axisAlignment: axisAlignment,
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class BounceSwitcher extends StatelessWidget {
  const BounceSwitcher({
    required this.child,
    this.duration = Effects.mediumDuration,
    this.reverseDuration,
    this.switchInCurve = Curves.easeOut,
    this.switchOutCurve = Curves.easeIn,
    this.layoutBuilder,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve switchInCurve, switchOutCurve;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
      transitionBuilder: (child, animation) {
        final tween = Tween<double>(begin: 0.0, end: 1.0);
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        );

        return ScaleTransition(
          scale: tween.animate(curve),
          child: child,
        );
      },
      child: child,
    );
  }
}

AnimatedSwitcherTransitionBuilder zoomTransitionBuilder(
  double scaleInFactor,
  double scaleOutFactor,
) =>
    (final child, final animation) {
      final bool isReversed = animation.status.isCompletedOrReversed;

      return ScaleTransition(
        scale: Tween<double>(
          begin: isReversed ? scaleOutFactor : scaleInFactor,
          end: 1.0,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    };

extension AnimationStatusExtension on AnimationStatus {
  bool get isCompletedOrReversed =>
      this == AnimationStatus.completed || this == AnimationStatus.reverse;
}

AnimatedSwitcherLayoutBuilder alignedLayoutBuilder(
  AlignmentGeometry alignment, {
  StackFit fit = StackFit.loose,
  Widget? Function(Widget?)? currentChildBuilder,
}) =>
    (
      Widget? currentChild,
      List<Widget> previousChildren,
    ) =>
        Stack(
          alignment: alignment,
          children: <Widget>[
            ...previousChildren,
            if (currentChildBuilder?.call(currentChild) ?? currentChild
                case final child?)
              child,
          ],
        );
