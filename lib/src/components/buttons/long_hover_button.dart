import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A button that triggers a callback when the pointer hovers over it for longer
/// than a specified duration.
class LongHoverButton extends StatefulWidget {
  const LongHoverButton({
    this.longHoverThreshold = Effects.longDuration,
    this.onHover,
    this.onExit,
    this.onLongHover,
    required this.child,
    super.key,
  });

  /// The duration after which the [onLongHover] callback is called.
  final Duration longHoverThreshold;

  /// The callback that is called when the pointer hovers over the button.
  final void Function(PointerHoverEvent)? onHover;

  /// The callback that is called when the pointer exits the button.
  final void Function(PointerExitEvent)? onExit;

  /// The callback that is called when the pointer hovers over the button for
  /// longer than [longHoverThreshold].
  final void Function(PointerHoverEvent)? onLongHover;

  /// The child widget.
  final Widget child;

  @override
  State<LongHoverButton> createState() => _LongHoverButtonState();
}

class _LongHoverButtonState extends State<LongHoverButton> {
  Timer? _longHoverTimer;

  void _handleHoverStart(PointerHoverEvent event) {
    widget.onHover?.call(event);
    _longHoverTimer?.cancel();
    _longHoverTimer = Timer(widget.longHoverThreshold, () {
      widget.onLongHover?.call(event);
    });
  }

  void _handleHoverEnd(PointerExitEvent event) {
    widget.onExit?.call(event);
    _longHoverTimer?.cancel();
  }

  @override
  void dispose() {
    _longHoverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onHover: _handleHoverStart,
    onExit: _handleHoverEnd,
    child: widget.child,
  );
}
