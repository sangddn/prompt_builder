part of 'ui.dart';

/// A [LinearGradient] that interpolates colors smoothly.
/// A modified version of: https://github.com/n-bernat/flutter_smooth_gradient/blob/master/lib/smooth_gradient.dart
class SmoothGradient extends LinearGradient {
  SmoothGradient({
    super.begin,
    super.end,
    super.tileMode,
    super.transform,
    required Color from,
    required Color to,
    Curve curve = Curves.easeInOut,
    int steps = 16,
  }) : super(
          colors: List.generate(
            steps + 1,
            (i) => Color.lerp(from, to, i / steps)!,
          ),
          stops: List.generate(
            steps + 1,
            (i) => curve.transform(i / steps),
          ),
        );
}
