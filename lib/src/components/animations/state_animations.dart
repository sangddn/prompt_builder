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

/// An animated, stateless version of Flutter's [FutureBuilder].
///
/// The default animation is a [SizeFadeSwitcher].
class AnimatedFutureBuilder<T> extends StatelessWidget {
  const AnimatedFutureBuilder({
    super.key,
    this.initialData,
    required this.future,
    this.transitionBuilder,
    required this.builder,
  });

  final T? initialData;
  final Future<T>? future;
  final TransitionWidgetBuilder? transitionBuilder;
  final AsyncWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: future,
        initialData: initialData,
        builder: (context, snapshot) {
          final child = builder(context, snapshot);
          return transitionBuilder?.call(context, child) ??
              StateAnimations.sizeFade(child);
        },
      );
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

  static Widget fade(
    Widget child, {
    Duration duration = Effects.shortDuration,
    Curve switchInCurve = Curves.easeOut,
    Curve switchOutCurve = Curves.easeIn,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
  }) =>
      AnimatedSwitcher(
        duration: duration,
        switchInCurve: switchInCurve,
        switchOutCurve: switchOutCurve,
        layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: child,
      );
}
