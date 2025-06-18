import 'package:flutter/material.dart';

/// A widget that provides a bouncing animation effect when tapped.
///
/// The widget scales down when pressed and bounces back up when released.
/// The animation can be customized with different durations, curves and scale factors.
///
/// Example:
/// ```dart
/// BouncingObject(
///   onTap: () => print('Tapped!'),
///   scaleFactor: 0.9,
///   child: Container(
///     width: 100,
///     height: 100,
///     color: Colors.blue,
///   ),
/// )
/// ```
class BouncingObject extends StatefulWidget {
  const BouncingObject({
    super.key,
    required this.onTap,
    required this.child,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
    this.onLongPress,
    this.onSecondaryTapDown,
    this.onAnimation,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.curve = Curves.decelerate,
    this.reverseCurve = Curves.decelerate,
    this.scaleFactor = 0.8,
    this.hitTestBehavior,
  }) : assert(
         scaleFactor >= 0.0 && scaleFactor <= 1.0,
         'The valid range of scaleFactor is from 0.0 to 1.0.',
       );

  /// A listener for the animation.
  ///
  /// This callback is called whenever the animation changes value.
  final void Function(AnimationController)? onAnimation;

  /// Called when the widget is tapped.
  ///
  /// Set to `null` to disable tap interactions.
  final VoidCallback? onTap;

  /// Called when a tap has been released.
  final void Function(TapUpDetails)? onTapUp;

  /// Called when a tap has been initiated.
  final void Function(TapDownDetails)? onTapDown;

  /// Called when a tap has been canceled.
  final VoidCallback? onTapCancel;

  /// Called when a long press gesture has been recognized.
  final VoidCallback? onLongPress;

  /// Called when a secondary tap has been initiated.
  final void Function(TapDownDetails)? onSecondaryTapDown;

  /// The duration of the scaling animation when releasing a tap.
  final Duration? duration;

  /// The duration of the scaling animation when initiating a tap.
  final Duration? reverseDuration;

  /// The curve of the scaling animation when releasing a tap.
  final Curve curve;

  /// The curve of the scaling animation when initiating a tap.
  final Curve? reverseCurve;

  /// The scale factor of the child widget when pressed.
  ///
  /// Must be between 0.0 and 1.0, where 1.0 means no scaling.
  final double scaleFactor;

  /// How the internal gesture detector should behave during hit testing.
  final HitTestBehavior? hitTestBehavior;

  /// The widget to apply the bouncing animation to.
  final Widget child;

  @override
  State<BouncingObject> createState() => _BouncingObjectState();
}

class _BouncingObjectState extends State<BouncingObject>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    reverseDuration: widget.reverseDuration,
    value: 1.0,
    lowerBound: widget.scaleFactor,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
    reverseCurve: widget.reverseCurve,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.onAnimation?.call(_controller);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.onTap?.call();
    _controller.reverse().then((_) {
      _controller.forward();
    });
  }

  void _onTapUp(TapUpDetails details) {
    widget.onTapUp?.call(details);
    _controller.forward();
  }

  void _onTapDown(TapDownDetails details) {
    widget.onTapDown?.call(details);
    _controller.reverse();
  }

  void _onTapCancel() {
    widget.onTapCancel?.call();
    _controller.forward();
  }

  void _onLongPress() {
    widget.onLongPress?.call();
    _controller.reverse().then((_) {
      _controller.forward();
    });
  }

  void _onSecondaryTapDown(TapDownDetails details) {
    widget.onSecondaryTapDown?.call(details);
    _controller.reverse().then((_) {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: widget.hitTestBehavior,
        onTapCancel: widget.onTap != null ? _onTapCancel : null,
        onTapDown: widget.onTap != null ? _onTapDown : null,
        onTapUp: widget.onTap != null ? _onTapUp : null,
        onTap: widget.onTap != null ? _onTap : null,
        onLongPress: widget.onLongPress != null ? _onLongPress : null,
        onSecondaryTapDown:
            widget.onSecondaryTapDown != null ? _onSecondaryTapDown : null,
        child: ScaleTransition(scale: _animation, child: widget.child),
      ),
    );
  }
}
