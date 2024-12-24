part of 'ui.dart';

abstract final class Effects {
  static const veryShortDuration = Duration(milliseconds: 150);
  static const shortDuration = Duration(milliseconds: 250);
  static const mediumDuration = Duration(milliseconds: 500);
  static const longDuration = Duration(milliseconds: 800);
  static const veryLongDuration = Duration(milliseconds: 1200);

  static const engagingCurve = Cubic(0.4, 0.0, 0.2, 1.0);
  static const playfulCurve = Cubic(0.22, 0.74, 0.38, 1.09);
  static const swiftOutCurve = Cubic(0.175, 0.885, 0.32, 1.1);
  static const snappyOutCurve = Cubic(0.19, 1, 0.22, 1);
  static const snappyInCurve = Cubic(0.22, 1, 0.19, 1);
  static const outQuartCurve = Cubic(0.165, 0.84, 0.44, 1);
  static const outQuintCurve = Cubic(0.23, 1, 0.32, 1);

  static const blur = BlurEffect(
    duration: Duration(milliseconds: 300),
    curve: Easing.emphasizedDecelerate,
    begin: Offset(8.0, 8.0),
    end: Offset.zero,
  );

  static const scaleIn = ScaleEffect(
    duration: Duration(milliseconds: 300),
    curve: Easing.emphasizedDecelerate,
    begin: Offset(1.1, 1.1),
    end: Offset(1.0, 1.0),
  );
}
