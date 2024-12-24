import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A rectangle border with continuous corners.
///
/// A shape similar to a rounded rectangle, but with a smoother transition from
/// the sides to the rounded corners.
///
/// The rendered shape roughly approximates that of a superellipse. In this
/// shape, the curvature of each 90º corner around the length of the arc is
/// approximately a gaussian curve instead of a step function as with a
/// traditional quarter circle round. The rendered rectangle is roughly a
/// superellipse with an n value of 5.
///
/// In an attempt to keep the shape of the rectangle the same regardless of its
/// dimension (and to avoid clipping of the shape), the radius will
/// automatically be lessened if its width or height is less than ~3x the
/// declared radius. The new resulting radius will always be maximal in respect
/// to the dimensions of the given rectangle.
///
/// The ~3 represents twice the ratio (ie. ~3/2) of a corner's declared radius
/// and the actual height and width of pixels that are manipulated to render it.
/// For example, if a rectangle had dimensions 80px x 100px, and a corner radius
/// of 25, in reality ~38 pixels in each dimension would be used to render a
/// corner and so ~76px x ~38px would be used to render both corners on a given
/// side.
///
/// This shape will always have 4 linear edges and 4 90º curves. However, for
/// rectangles with small values of width or height (ie.  <20 lpx) and a low
/// aspect ratio (ie. <0.3), the rendered shape will appear to have just 2
/// linear edges and 2 180º curves.
///
/// The example below shows how to render a continuous rectangle on screen.
///
/// {@tool sample}
/// ```dart
/// Widget build(BuildContext context) {
///   return Container(
///     alignment: Alignment.center,
///     child: Material(
///       color: Colors.blueAccent[400],
///       shape: const ContinuousRectangleBorder(cornerRadius: 75.0),
///       child: const SizedBox(
///         height: 200.0,
///         width: 200.0,
///       ),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// The image below depicts a [Superellipse] with a width
/// and height of 200 and a curve radius of 75.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/painting/Shape.continuous_rectangle.png)
///
/// See also:
///
/// * [RoundedRectangleBorder], which is a rectangle whose corners are
///   precisely quarter circles.
/// * [ContinuousStadiumBorder], which is a stadium whose two edges have a
///   continuous transition into its two 180º curves.
/// * [StadiumBorder], which is a rectangle with semi-circles on two parallel
///   edges.
/// 
/// ! From: https://github.com/flutter/flutter/pull/26295#issue-397432806
/// 
class Superellipse extends ShapeBorder {
  /// Creates a continuous cornered rectangle border.
  ///
  /// The [side] and [cornerRadius] arguments must not be null.
  const Superellipse({
    this.side = BorderSide.none,
    this.cornerRadius = 0.0,
  });

  static const border4 = Superellipse(cornerRadius: 4.0);
  static const border8 = Superellipse(cornerRadius: 8.0);
  static const border12 = Superellipse(cornerRadius: 12.0);
  static const border16 = Superellipse(cornerRadius: 16.0);
  static const border24 = Superellipse(cornerRadius: 24.0);
  static const border32 = Superellipse(cornerRadius: 32.0);

  /// The radius for each corner.
  ///
  /// The radius will be clamped to 0 if a value less than 0 is entered as the
  /// radius. By default the radius is 0. This value must not be null.
  ///
  /// Unlike [RoundedRectangleBorder], there is only a single radius value used
  /// to describe the radius for every corner.
  final double cornerRadius;

  /// The style of this border.
  ///
  /// If the border side width is larger than 1/10 the length of the smallest
  /// dimension, the interior shape's corners will no longer resemble those of
  /// the exterior shape. If concentric corners are desired for a stroke width
  /// greater than 1/10 the length of the smallest dimension, it is recommended
  /// to use a [Stack] widget, placing a smaller [Superellipse] with
  /// the same 'cornerRadius' on top of a larger one.
  ///
  /// By default this value is [BorderSide.none]. It must not be null.
  final BorderSide side;

  Path _getPath(Rect rect) {
    // We need to change the dimensions of the rect in the event that the
    // shape has a side width as the stroke is drawn centered on the border of
    // the shape instead of inside as with the rounded rect and stadium.
    if (side.width > 0.0) {
      rect = rect.deflate(side.width / 2.0);
    }

    late double limitedRadius;
    final double width = rect.width;
    final double height = rect.height;
    final double centerX = rect.center.dx;
    final double centerY = rect.center.dy;
    final double radius = math.max(0.0, cornerRadius);

    // These equations give the x and y values for each of the 8 mid and corner
    // points on a rectangle.
    //
    // For example, leftX(k) will give the x value on the left side of the shape
    // that is precisely `k` distance from the left edge of the shape for the
    // predetermined 'limitedRadius' value.
    double leftX(double x) {
      return centerX + x * limitedRadius - width / 2;
    }

    double rightX(double x) {
      return centerX - x * limitedRadius + width / 2;
    }

    double topY(double y) {
      return centerY + y * limitedRadius - height / 2;
    }

    double bottomY(double y) {
      return centerY - y * limitedRadius + height / 2;
    }

    // Renders the default superelliptical rounded rect shape where there are
    // 4 straight edges and 4 90º corners. Approximately renders a superellipse
    // with n value of 5.
    //
    // Code was inspired from the code listed on this website:
    // https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles
    //
    // The shape is drawn from the top midpoint to the upper right hand corner
    // in a clockwise fashion around to the upper left hand corner.
    Path bezierRoundedRect() {
      return Path()
        ..moveTo(leftX(1.52866483), topY(0.0))
        ..lineTo(rightX(1.52866471), topY(0.0))
        ..cubicTo(
          rightX(1.08849323),
          topY(0.0),
          rightX(0.86840689),
          topY(0.0),
          rightX(0.66993427),
          topY(0.06549600),
        )
        ..lineTo(rightX(0.63149399), topY(0.07491100))
        ..cubicTo(
          rightX(0.37282392),
          topY(0.16905899),
          rightX(0.16906013),
          topY(0.37282401),
          rightX(0.07491176),
          topY(0.63149399),
        )
        ..cubicTo(
          rightX(0),
          topY(0.86840701),
          rightX(0.0),
          topY(1.08849299),
          rightX(0.0),
          topY(1.52866483),
        )
        ..lineTo(rightX(0.0), bottomY(1.52866471))
        ..cubicTo(
          rightX(0.0),
          bottomY(1.08849323),
          rightX(0.0),
          bottomY(0.86840689),
          rightX(0.06549600),
          bottomY(0.66993427),
        )
        ..lineTo(rightX(0.07491100), bottomY(0.63149399))
        ..cubicTo(
          rightX(0.16905899),
          bottomY(0.37282392),
          rightX(0.37282401),
          bottomY(0.16906013),
          rightX(0.63149399),
          bottomY(0.07491176),
        )
        ..cubicTo(
          rightX(0.86840701),
          bottomY(0),
          rightX(1.08849299),
          bottomY(0.0),
          rightX(1.52866483),
          bottomY(0.0),
        )
        ..lineTo(leftX(1.52866483), bottomY(0.0))
        ..cubicTo(
          leftX(1.08849323),
          bottomY(0.0),
          leftX(0.86840689),
          bottomY(0.0),
          leftX(0.66993427),
          bottomY(0.06549600),
        )
        ..lineTo(leftX(0.63149399), bottomY(0.07491100))
        ..cubicTo(
          leftX(0.37282392),
          bottomY(0.16905899),
          leftX(0.16906013),
          bottomY(0.37282401),
          leftX(0.07491176),
          bottomY(0.63149399),
        )
        ..cubicTo(
          leftX(0),
          bottomY(0.86840701),
          leftX(0.0),
          bottomY(1.08849299),
          leftX(0.0),
          bottomY(1.52866483),
        )
        ..lineTo(leftX(0.0), topY(1.52866471))
        ..cubicTo(
          leftX(0.0),
          topY(1.08849323),
          leftX(0.0),
          topY(0.86840689),
          leftX(0.06549600),
          topY(0.66993427),
        )
        ..lineTo(leftX(0.07491100), topY(0.63149399))
        ..cubicTo(
          leftX(0.16905899),
          topY(0.37282392),
          leftX(0.37282401),
          topY(0.16906013),
          leftX(0.63149399),
          topY(0.07491176),
        )
        ..cubicTo(
          leftX(0.86840701),
          topY(0),
          leftX(1.08849299),
          topY(0.0),
          leftX(1.52866483),
          topY(0.0),
        )
        ..close();
    }

    // The ratio of the declared corner radius to the total affected pixels to
    // render the corner. For example if the declared radius were 25px then
    // totalAffectedCornerPixelRatio * 25 (~38) pixels would be affected.
    const double totalAffectedCornerPixelRatio = 1.52865;

    // The radius multiplier where the resulting shape will concave with a
    // height and width of any value.
    //
    // If the shortest side length to radius ratio drops below this value, the
    // radius must be lessened to avoid clipping (ie. concavity) of the shape.
    //
    // This value comes from the website where the other equations and curves
    // were found
    // (https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles),
    // however it represents the ratio of the total 90º curve width or height to
    // the width or height of the smallest rectangle dimension.
    const double minimalUnclippedSideToCornerRadiusRatio =
        2.0 * totalAffectedCornerPixelRatio;

    // The multiplier of the radius in comparison to the smallest edge length
    // used to describe the minimum radius for this shape.
    //
    // This is multiplier used in the case of an extreme aspect ratio and a
    // small extent value. It can be less than 'maxMultiplier' because there
    // are not enough pixels to render the clipping of the shape at this size so
    // it appears to still be concave (whereas mathematically it's convex).
    const double minimalEdgeLengthSideToCornerRadiusRatio = 2.0;

    // The minimum edge length at which the corner radius multiplier must be at
    // its maximum so as to maintain the appearance of a perfectly concave,
    // non-lozenge shape.
    //
    // If the smallest edge length is less than this value, the dynamic radius
    // value can be made smaller than the 'maxMultiplier' while the rendered
    // shape still does not visually clip.
    const double minRadiusEdgeLength = 200.0;

    final double minSideLength = math.min(rect.width, rect.height);

    // As the minimum side edge length (where the round is occurring)
    // approaches 0, the limitedRadius approaches 2 so as to maximize
    // roundness (to make the shape with the largest radius that doesn't clip).
    // As the edge length approaches 200, the limitedRadius approaches ~3 –- the
    // multiplier of the radius value where the resulting shape is concave (ie.
    // does not visually clip) at any dimension.
    final double multiplier = ui.lerpDouble(
      minimalEdgeLengthSideToCornerRadiusRatio,
      minimalUnclippedSideToCornerRadiusRatio,
      minSideLength / minRadiusEdgeLength,
    )!;
    limitedRadius = math.min(radius, minSideLength / multiplier);
    return bezierRoundedRect();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) {
      return;
    }
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final double width = side.width;
        final Paint paint = side.toPaint();
        if (width != 0.0) {
          canvas.drawPath(getOuterPath(rect), paint);
        }
    }
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect.deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return Superellipse(
      side: side.scale(t),
      cornerRadius: cornerRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is Superellipse) {
      return Superellipse(
        side: BorderSide.lerp(a.side, side, t),
        cornerRadius: ui.lerpDouble(a.cornerRadius, cornerRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is Superellipse) {
      return Superellipse(
        side: BorderSide.lerp(side, b.side, t),
        cornerRadius: ui.lerpDouble(cornerRadius, b.cornerRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    final Superellipse typedOther =
        // ignore: test_types_in_equals
        other as Superellipse;
    return side == typedOther.side && cornerRadius == typedOther.cornerRadius;
  }

  @override
  int get hashCode => Object.hash(side, cornerRadius);

  @override
  String toString() {
    return '$runtimeType($side, $cornerRadius)';
  }
}

/// A stadium border with continuous corners.
///
/// The code for this SquircleStadium implementation is from this unmerged PR
/// https://github.com/flutter/flutter/pull/27523 which in the comment
/// https://github.com/flutter/flutter/pull/27523#issuecomment-597373748 was
/// praised for its iOS like fidelity.
///
/// The original code can be found here:
/// https://github.com/jslavitz/flutter/blob/4b2d32f9ebb1192bce695927cc3cab13e94cce39/packages/flutter/lib/src/painting/continuous_stadium_border.dart
///
/// This code has been migrated to null safety and changed to implement support
/// for [BorderSide.strokeAlign] by @rydmike.
///
/// The original doc comment below needs updates.
///
/// ----
///
/// A shape similar to a stadium, but with a smoother transition from
/// each linear edge to its 180º curves. Each 180º curve is approximately half
/// an ellipse.
///
/// In this shape, the curvature of each 180º curve around the length of the arc
/// is approximately a gaussian curve instead of a step function as with a
/// traditional half circle round.
///
/// The ~3 represents twice the ratio (ie. ~3/2) of a corner's declared radius
/// and the actual height and width of pixels that are manipulated to render it.
/// For example, if a rectangle had dimensions 80px x 100px, and a corner radius
/// of 25, in reality ~38 pixels in each dimension would be used to render a
/// corner and so ~76px x ~38px would be used to render both corners on a given
/// side.
///
/// The two 180º arcs will always be positioned on the shorter side of the
/// rectangle like with the traditional [StadiumBorder] shape.
///
/// {@tool sample}
/// ```dart
/// Widget build(BuildContext context) {
///   return Material(
///     color: Colors.blueAccent[400],
///     shape: const SquircleStadiumBorder(),
///     child: const SizedBox(
///       height: 100.0,
///       width: 200.0,
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
/// * [RoundedRectangleBorder], which is a rectangle whose corners are
///   precisely quarter circles.
/// * [ContinuousRectangleBorder], which is a rectangle whose 4 edges have
///   a continuous transition into each of its four corners.
/// * [StadiumBorder], which is a rectangle with semi-circles on two parallel
///   edges.
class SquircleStadiumBorder extends ShapeBorder {
  /// Creates a continuous stadium border.
  ///
  /// The [side], argument must not be null.
  const SquircleStadiumBorder({
    this.side = BorderSide.none,
  });

  /// The style of this border.
  ///
  /// If the border side width is larger than 1/10 the length of the smallest
  /// dimension, the interior shape's corners will no longer resemble those of
  /// the exterior shape. If concentric corners are desired for a stroke width
  /// greater than 1/10 the length of the smallest rectangle dimension, it is
  /// recommended to use a [Stack] widget, placing a smaller
  /// [SquircleStadiumBorder] with the on top of a
  /// larger one.
  ///
  /// By default this value is [BorderSide.none]. It also must not be null.
  final BorderSide side;

  Path _getPath(final Rect rectangle) {
    // The two 180º arcs will always be positioned on the shorter side of the
    // rectangle like with the traditional stadium border shape.

    // The side width that is capped by the smallest dimension of the rectangle.
    // It represents the side width value used to render the stroke.
    final double actualSideWidth =
        math.min(side.width, math.min(rectangle.width, rectangle.height) / 2.0);

    // The ratio of the declared corner radius to the total affected pixels
    // along each axis to render the corner. For example if the declared radius
    // were 25px then totalAffectedCornerPixelRatio * 25 (~38) pixels would be
    // affected along each axis.
    //
    // It is also the multiplier where the resulting shape will be convex with
    // a height and width of any value. Below this value, noticeable clipping
    // will be seen at large rectangle dimensions.
    //
    // If the shortest side length to radius ratio drops below this value, the
    // radius must be lessened to avoid clipping (ie. concavity) of the shape.
    //
    // This value comes from the website where the other equations and curves
    // were found
    // (https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles).
    const double totalAffectedCornerPixelRatio = 1.52865;

    // The ratio of the radius to the magnitude of pixels on a given side that
    // are used to construct the two corners.
    const double minimalUnclippedSideToCornerRadiusRatio =
        2.0 * totalAffectedCornerPixelRatio;

    const double minimalEdgeLengthSideToCornerRadiusRatio =
        1.0 / minimalUnclippedSideToCornerRadiusRatio;

    // The maximum aspect ratio of the width and height of the given rect before
    // clamping on one dimension will occur. Roughly 0.79.
    const double maxEdgeLengthAspectRatio = 0.79;

    final double rectWidth = rectangle.width;
    final double rectHeight = rectangle.height;
    final bool widthLessThanHeight = rectWidth < rectHeight;
    final double width = widthLessThanHeight
        ? rectWidth.clamp(
            0.0,
            maxEdgeLengthAspectRatio * (rectHeight + actualSideWidth) -
                actualSideWidth,
          )
        : rectWidth;
    final double height = widthLessThanHeight
        ? rectHeight
        : rectHeight.clamp(
            0.0,
            maxEdgeLengthAspectRatio * (rectWidth + actualSideWidth) -
                actualSideWidth,
          );

    final double centerX = rectangle.center.dx;
    final double centerY = rectangle.center.dy;
    final double originX = centerX - width / 2.0;
    final double originY = centerY - height / 2.0;
    final double minDimension = math.min(width, height);
    final double radius =
        minDimension * minimalEdgeLengthSideToCornerRadiusRatio;

    // These equations give the x and y values for each of the 8 mid and corner
    // points on a rectangle.
    //
    // For example, leftX(k) will give the x value on the left side of the shape
    // that is precisely `k` distance from the left edge of the shape for the
    // predetermined 'limitedRadius' value.
    double leftX(double x) {
      return centerX + x * radius - width / 2;
    }

    double rightX(double x) {
      return centerX - x * radius + width / 2;
    }

    double topY(double y) {
      return centerY + y * radius - height / 2;
    }

    double bottomY(double y) {
      return centerY - y * radius + height / 2;
    }

    double bottomMidY(double y) {
      return originY + height - y * radius;
    }

    double leftMidX(double x) {
      return originX + x * height;
    }

    double rightMidX(double x) {
      return originX + width - x * radius;
    }

    // An elliptical shape with 2 straight edges and two 180º curves. The width
    // is greater than the height.
    //
    // Code was inspired from the code listed on this website:
    // https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles
    //
    // The shape is drawn from the top midpoint to the upper right hand corner
    // in a clockwise fashion around to the upper left hand corner.
    Path bezierStadiumHorizontal() {
      return Path()
        ..moveTo(leftX(2.00593972), topY(0.0))
        ..lineTo(originX + width - 1.52866483 * radius, originY)
        ..cubicTo(
          rightX(1.63527834),
          topY(0.0),
          rightX(1.29884040),
          topY(0.0),
          rightX(0.99544263),
          topY(0.10012127),
        )
        ..lineTo(rightX(0.93667978), topY(0.11451437))
        ..cubicTo(
          rightX(0.37430558),
          topY(0.31920183),
          rightX(0.00000051),
          topY(0.85376567),
          rightX(0.00000051),
          topY(1.45223188),
        )
        ..cubicTo(
          rightMidX(0.0),
          centerY,
          rightMidX(0.0),
          centerY,
          rightMidX(0.0),
          centerY,
        )
        ..lineTo(rightMidX(0.0), centerY)
        ..cubicTo(
          rightMidX(0.0),
          centerY,
          rightMidX(0.0),
          centerY,
          rightMidX(0.0),
          centerY,
        )
        ..lineTo(rightX(0.0), bottomY(1.45223165))
        ..cubicTo(
          rightX(0.0),
          bottomY(0.85376561),
          rightX(0.37430558),
          bottomY(0.31920174),
          rightX(0.93667978),
          bottomY(0.11451438),
        )
        ..cubicTo(
          rightX(1.29884040),
          bottomY(0.0),
          rightX(1.63527834),
          bottomY(0.0),
          rightX(2.30815363),
          bottomY(0.0),
        )
        ..lineTo(originX + 1.52866483 * radius, originY + height)
        ..cubicTo(
          leftX(1.63527822),
          bottomY(0.0),
          leftX(1.29884040),
          bottomY(0.0),
          leftX(0.99544257),
          bottomY(0.10012124),
        )
        ..lineTo(leftX(0.93667972), bottomY(0.11451438))
        ..cubicTo(
          leftX(0.37430549),
          bottomY(0.31920174),
          leftX(-0.00000007),
          bottomY(0.85376561),
          leftX(-0.00000001),
          bottomY(1.45223176),
        )
        ..cubicTo(
          leftMidX(0.0),
          centerY,
          leftMidX(0.0),
          centerY,
          leftMidX(0.0),
          centerY,
        )
        ..lineTo(leftMidX(0.0), centerY)
        ..cubicTo(
          leftMidX(0.0),
          centerY,
          leftMidX(0.0),
          centerY,
          leftMidX(0.0),
          centerY,
        )
        ..lineTo(leftX(-0.00000001), topY(1.45223153))
        ..cubicTo(
          leftX(0.00000004),
          topY(0.85376537),
          leftX(0.37430561),
          topY(0.31920177),
          leftX(0.93667978),
          topY(0.11451436),
        )
        ..cubicTo(
          leftX(1.29884040),
          topY(0.0),
          leftX(1.63527822),
          topY(0.0),
          leftX(2.30815363),
          topY(0.0),
        )
        ..lineTo(leftX(2.00593972), topY(0.0))
        ..close();
    }

    // An elliptical shape which has 2 straight edges and two 180º curves. The
    // height is greater than the width.
    //
    // Code was inspired from the code listed on this website:
    // https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles
    //
    // The shape is drawn from the top midpoint to the upper right hand corner
    // in a clockwise fashion around to the upper left hand corner.
    Path bezierStadiumVertical() {
      return Path()
        ..moveTo(centerX, topY(0.0))
        ..lineTo(centerX, topY(0.0))
        ..cubicTo(centerX, topY(0.0), centerX, topY(0.0), centerX, topY(0.0))
        ..lineTo(rightX(1.45223153), topY(0.0))
        ..cubicTo(
          rightX(0.85376573),
          topY(0.00000001),
          rightX(0.31920189),
          topY(0.37430537),
          rightX(0.11451442),
          topY(0.93667936),
        )
        ..cubicTo(
          rightX(0.0),
          topY(1.29884040),
          rightX(0.0),
          topY(1.63527822),
          rightX(0.0),
          topY(2.30815387),
        )
        ..lineTo(originX + width, originY + height - 1.52866483 * radius)
        ..cubicTo(
          rightX(0.0),
          bottomY(1.63527822),
          rightX(0.0),
          bottomY(1.29884028),
          rightX(0.10012137),
          bottomY(0.99544269),
        )
        ..lineTo(rightX(0.11451442), bottomY(0.93667972))
        ..cubicTo(
          rightX(0.31920189),
          bottomY(0.37430552),
          rightX(0.85376549),
          bottomY(0.0),
          rightX(1.45223165),
          bottomY(0.0),
        )
        ..cubicTo(
          centerX,
          bottomMidY(0.0),
          centerX,
          bottomMidY(0.0),
          centerX,
          bottomMidY(0.0),
        )
        ..lineTo(centerX, bottomMidY(0.0))
        ..cubicTo(
          centerX,
          bottomMidY(0.0),
          centerX,
          bottomMidY(0.0),
          centerX,
          bottomMidY(0.0),
        )
        ..lineTo(leftX(1.45223141), bottomY(0.0))
        ..cubicTo(
          leftX(0.85376543),
          bottomY(0.0),
          leftX(0.31920192),
          bottomY(0.37430552),
          leftX(0.11451446),
          bottomY(0.93667972),
        )
        ..cubicTo(
          leftX(0.0),
          bottomY(1.29884028),
          leftX(0.0),
          bottomY(1.63527822),
          leftX(0.0),
          bottomY(2.30815387),
        )
        ..lineTo(originX, originY + 1.52866483 * radius)
        ..cubicTo(
          leftX(0.0),
          topY(1.63527822),
          leftX(0.0),
          topY(1.29884040),
          leftX(0.10012126),
          topY(0.99544257),
        )
        ..lineTo(leftX(0.11451443), topY(0.93667966))
        ..cubicTo(
          leftX(0.31920189),
          topY(0.37430552),
          leftX(0.85376549),
          topY(0.0),
          leftX(1.45223153),
          topY(0.0),
        )
        ..cubicTo(centerX, topY(0.0), centerX, topY(0.0), centerX, topY(0.0))
        ..lineTo(centerX, topY(0.0))
        ..close();
    }

    return width > minimalUnclippedSideToCornerRadiusRatio * radius
        ? bezierStadiumHorizontal()
        : bezierStadiumVertical();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect.deflate(side.strokeInset));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        if (side.width != 0.0) {
          final Rect adjustedRect = rect.inflate(side.strokeOffset / 2);
          final Path path = _getPath(adjustedRect);
          final Paint paint = side.toPaint();
          paint.strokeJoin = StrokeJoin.round;
          canvas.drawPath(path, paint);
        }
    }
  }

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.all(math.max(side.strokeInset, 0));

  @override
  ShapeBorder scale(double t) {
    return SquircleStadiumBorder(
      side: side.scale(t),
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is SquircleStadiumBorder) {
      return SquircleStadiumBorder(
        side: BorderSide.lerp(a.side, side, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is SquircleStadiumBorder) {
      return SquircleStadiumBorder(
        side: BorderSide.lerp(side, b.side, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return other is SquircleStadiumBorder && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'SquircleStadiumBorder')}($side)';
  }
}
