import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';

/// An animated version of [StateProvider] that animates the changes of the
/// contained value.
///
class AnimatedStateProvider<T> extends StateProvider<T> {
  AnimatedStateProvider({
    Duration duration = Effects.shortDuration,
    Curve curve = Effects.snappyOutCurve,
    required super.createInitialValue,
    super.onValueChanged,
    super.initState,
    super.dispose,
    required T Function(T? oldValue, T newValue, double t) lerp,
    TransitionBuilder? builder,
    super.valueBuilder,
    super.updateShouldNotify,
    super.lazy,
    Widget? child,
    super.key,
  }) : super(
          child: _AnimatedConsumer<T>(
            duration: duration,
            curve: curve,
            lerp: lerp,
            builder: builder,
            child: child,
          ),
        );
}

class _AnimatedConsumer<T> extends StatefulWidget {
  const _AnimatedConsumer({
    required this.duration,
    required this.curve,
    required this.lerp,
    required this.builder,
    required this.child,
    super.key,
  });

  final Duration duration;
  final Curve curve;
  final T Function(T? oldValue, T newValue, double t) lerp;
  final TransitionBuilder? builder;
  final Widget? child;

  @override
  State<_AnimatedConsumer<T>> createState() => __AnimatedConsumerState<T>();
}

class __AnimatedConsumerState<T> extends State<_AnimatedConsumer<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late CurvedAnimation _curvedAnimation;

  T? _oldValue;
  late T _value = context.read<ValueNotifier<T>>().value;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedConsumer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newValue = context.watch<ValueNotifier<T>>().value;
    if (!_controller.isCompleted) {
      _controller.stop();
    }
    if (newValue != _oldValue) {
      _value = newValue;
      _controller.forward(from: 0.0).then((_) {
        _oldValue = newValue;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _curvedAnimation,
        builder: (context, child) => Provider<T>.value(
          value: _curvedAnimation.isAnimating
              ? widget.lerp(_oldValue, _value, _curvedAnimation.value)
              : _value,
          builder: widget.builder,
          child: child,
        ),
        child: widget.child,
      );
}
