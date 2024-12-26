import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

typedef TransitionWidgetBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

/// An animated version of Flutter's [State].
///
/// The default animation is a [SizeFadeSwitcher]. Override [buildAnimation] to
/// customize the animation.
///
abstract class AnimatedState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) =>
      buildAnimation(context, buildChild(context));

  Widget buildChild(BuildContext context);
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.sizeFade(child);
}

/// An animated version of Flutter's [StatelessWidget].
///
/// The default animation is a [SizeFadeSwitcher]. Override [buildAnimation] to
/// customize the animation.
///
abstract class AnimatedStatelessWidget extends StatelessWidget {
  const AnimatedStatelessWidget({super.key});

  Widget buildChild(BuildContext context);
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.sizeFade(child);

  @override
  Widget build(BuildContext context) =>
      buildAnimation(context, buildChild(context));
}

/// Pre-built high-quality animations to be used with StateAnimations.
///
class StateAnimations {
  /// Animates a widget with a fade and "re-size" effect.
  ///
  /// When the child changes, the new child will fade in and grow from the
  /// [alignment] along the [axis]. The old child will fade out and shrink.
  ///
  /// Note that the size effect always takes place, even if the layout size
  /// of the child does not change. For such cases, consider using
  /// [fadeWithAnimatedSize] instead.
  ///
  static Widget sizeFade(
    Widget child, {
    Duration duration = Effects.shortDuration,
    Duration? reverseDuration,
    Axis axis = Axis.vertical,
    double alignment = -1.0,
    Curve switchInCurve = Curves.easeOut,
    Curve switchOutCurve = Curves.easeIn,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    bool enableBlur = false,
    bool enableScale = false,
  }) =>
      SizeFadeSwitcher(
        duration: duration,
        reverseDuration: reverseDuration,
        axis: axis,
        axisAlignment: alignment,
        switchInCurve: switchInCurve,
        switchOutCurve: switchOutCurve,
        layoutBuilder: layoutBuilder,
        child: child,
      );
}
