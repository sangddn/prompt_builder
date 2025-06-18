import 'dart:math' show pi;

import 'package:flutter/widgets.dart';

import '../../core/core.dart';

class AnimatedCircularProgress extends ImplicitlyAnimatedWidget {
  const AnimatedCircularProgress({
    this.color,
    this.size = 32.0,
    required this.percentage,
    super.curve = Effects.snappyOutCurve,
    super.duration = Effects.mediumDuration,
    super.onEnd,
    super.key,
  });

  final Color? color;
  final double size;
  final double percentage;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState
    extends AnimatedWidgetBaseState<AnimatedCircularProgress> {
  Tween<double>? _size;
  Tween<double>? _percentage;
  ColorTween? _color;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _size =
        visitor(
              _size,
              widget.size,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _percentage =
        visitor(
              _percentage,
              widget.percentage,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _color =
        visitor(
              _color,
              widget.color ?? const Color(0x00000000),
              (dynamic value) =>
                  ColorTween(begin: value as Color? ?? const Color(0x00000000)),
            )
            as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(_size!.evaluate(animation), _size!.evaluate(animation)),
      painter: PieChartPainter(
        percentage: _percentage!.evaluate(animation),
        color: _color!.evaluate(animation) ?? const Color(0x00000000),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  const PieChartPainter({
    required this.percentage,
    required this.color,
    this.outerCircleStrokeWidth = 2.0,
    this.innerOuterGap = 1.5,
  });

  final double percentage;
  final Color color;
  final double outerCircleStrokeWidth;
  final double innerOuterGap;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the circle
    final paint =
        Paint()
          ..color = color.replaceOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = outerCircleStrokeWidth;

    // Paint for the slice
    final slicePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Calculate the radius
    final radius = size.width / 2;

    // Draw the blue circle outline
    canvas.drawCircle(
      Offset(radius, radius),
      radius - paint.strokeWidth,
      paint,
    );

    // Draw the slice based on percentage
    final angle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(radius, radius),
        radius: radius - outerCircleStrokeWidth - innerOuterGap * 2,
      ),
      -pi / 2, // Starting angle (top of the circle)
      angle, // Sweep angle based on percentage
      true,
      slicePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
