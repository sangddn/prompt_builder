import 'package:flutter/material.dart';

import '../../core/core.dart';

class DottedLine extends StatelessWidget {
  const DottedLine({
    this.color,
    this.strokeWidth,
    this.dashWidth = 4.0,
    this.dashSpace = 4.0,
    this.indent,
    this.endIndent,
    this.height,
    super.key,
  });

  final Color? color;
  final double? strokeWidth, indent, endIndent, height;
  final double dashWidth, dashSpace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerTheme = theme.dividerTheme;
    final color = this.color ?? PColors.gray.resolveFrom(context);
    final strokeWidth = this.strokeWidth ?? dividerTheme.thickness ?? 1;
    final height = this.height ?? dividerTheme.space ?? strokeWidth;
    final indent = this.indent ?? dividerTheme.indent ?? 0.0;
    final endIndent = this.endIndent ?? dividerTheme.endIndent ?? 0.0;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: height / 2,
        bottom: height / 2,
        start: indent,
        end: endIndent,
      ),
      child: CustomPaint(
        painter: DashedLinePainter(
          color: color,
          strokeWidth: strokeWidth,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  const DashedLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  final Color color;
  final double strokeWidth, dashWidth, dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    var startX = 0.0;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
