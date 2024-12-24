import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/core.dart';
import '../components.dart';

class AnimateOnHover extends StatefulWidget {
  const AnimateOnHover({
    required this.effects,
    required this.child,
    super.key,
  });

  final List<Effect<dynamic>> effects;
  final Widget child;

  @override
  State<AnimateOnHover> createState() => _AnimateOnHoverState();
}

class _AnimateOnHoverState extends State<AnimateOnHover> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: widget.child.animate(
        target: _isHovering ? 1.0 : 0.0,
        effects: widget.effects,
      ),
    );
  }
}

class AnimateOnTap extends StatefulWidget {
  const AnimateOnTap({
    required this.effects,
    this.onTap,
    required this.child,
    super.key,
  });

  final List<Effect<dynamic>> effects;
  final VoidCallback? onTap;
  final Widget child;

  @override
  State<AnimateOnTap> createState() => _AnimateOnTapState();
}

class _AnimateOnTapState extends State<AnimateOnTap> {
  bool _isPressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressing = true),
      onTapUp: (_) => setState(() => _isPressing = false),
      onTapCancel: () => setState(() => _isPressing = false),
      onTap: widget.onTap,
      child: widget.child.animate(
        target: _isPressing ? 1.0 : 0.0,
        effects: widget.effects,
      ),
    );
  }
}

class EnlargeOnHover extends StatelessWidget {
  const EnlargeOnHover({
    this.duration = Effects.veryShortDuration,
    this.curve = Curves.easeInQuad,
    this.scale = 1.1,
    required this.child,
    super.key,
  });

  final Duration duration;
  final Curve curve;
  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimateOnHover(
      effects: [
        ScaleEffect(
          begin: const Offset(1.0, 1.0),
          end: Offset(scale, scale),
          duration: duration,
          curve: curve,
        ),
      ],
      child: child,
    );
  }
}

class ShimmerOnHover extends StatelessWidget {
  const ShimmerOnHover({
    this.duration = Effects.mediumDuration,
    this.curve = Curves.easeInOut,
    required this.child,
    super.key,
  });

  final Duration duration;
  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimateOnHover(
      effects: [
        ShimmerEffect(
          duration: duration,
          curve: curve,
        ),
      ],
      child: child,
    );
  }
}

class JumpingCard extends StatefulWidget {
  const JumpingCard({
    required this.onTap,
    this.jumpScale = -0.2,
    required this.child,
    super.key,
  });

  final double jumpScale;
  final VoidCallback? onTap;
  final Widget child;

  @override
  State<JumpingCard> createState() => _JumpingCardState();
}

class _JumpingCardState extends State<JumpingCard> {
  @override
  Widget build(BuildContext context) {
    return DisambiguatedHoverTapBuilder(
      onTap: widget.onTap,
      builder: (context, isHovering, isPressing) => widget.child
          .animate(
            target: isHovering && !isPressing ? 1.0 : 0.0,
          )
          .slideY(
            duration: Effects.veryShortDuration,
            curve: Curves.easeInOut,
            begin: 0.0,
            end: widget.jumpScale,
          ),
    );
  }
}
