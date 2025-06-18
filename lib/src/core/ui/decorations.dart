part of 'ui.dart';

const k32APadding = EdgeInsets.all(32.0);
const k24APadding = EdgeInsets.all(24.0);
const k16APadding = EdgeInsets.all(16.0);
const k12APadding = EdgeInsets.all(12.0);
const k8APadding = EdgeInsets.all(8.0);
const k6APadding = EdgeInsets.all(6.0);
const k4APadding = EdgeInsets.all(4.0);

const k32HPadding = EdgeInsets.symmetric(horizontal: 32.0);
const k24HPadding = EdgeInsets.symmetric(horizontal: 24.0);
const k16HPadding = EdgeInsets.symmetric(horizontal: 16.0);
const k12HPadding = EdgeInsets.symmetric(horizontal: 12.0);
const k8HPadding = EdgeInsets.symmetric(horizontal: 8.0);
const k4HPadding = EdgeInsets.symmetric(horizontal: 4.0);

const k32VPadding = EdgeInsets.symmetric(vertical: 32.0);
const k24VPadding = EdgeInsets.symmetric(vertical: 24.0);
const k16VPadding = EdgeInsets.symmetric(vertical: 16.0);
const k12VPadding = EdgeInsets.symmetric(vertical: 12.0);
const k8VPadding = EdgeInsets.symmetric(vertical: 8.0);
const k4VPadding = EdgeInsets.symmetric(vertical: 4.0);

const k24H16VPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
const k24H12VPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
const k24H8VPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0);
const k16H12VPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
const k16H8VPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
const k16H4VPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0);
const k12H8VPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
const k12H4VPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0);
const k8H4VPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);

List<BoxShadow> elevation(
  double elevation, {
  bool isOuter = false,
  bool increaseIntensity = false,
  Color baseColor = Colors.black,
}) {
  if (elevation < 0.0) {
    return [];
  }

  return [
    BoxShadow(
      color: baseColor.replaceOpacity(
        0.08 + (increaseIntensity ? 1.0 : 0.0) * elevation * 0.01,
      ),
      blurRadius: 4.0 + elevation * 2,
      offset: isOuter ? Offset.zero : Offset(0, elevation),
      // spreadRadius: isOuter ? elevation : 0.0,
      blurStyle: isOuter ? BlurStyle.outer : BlurStyle.normal,
    ),
  ];
}

List<BoxShadow> focusedShadows({
  double elevation = 1.0,
  Color baseColor = Colors.black,
  double opacity = 0.06,
  BlurStyle style = BlurStyle.normal,
  Offset offsetDelta = Offset.zero,
  double offsetFactor = 1.0,
}) => List.generate(6, (index) {
  final factor = pow(2, index - 2).toDouble() * elevation;
  final blur = switch (index) {
    0 || 1 => index.toDouble(),
    _ => 3 * factor,
  };
  final yOffset = blur;
  final spread = switch (index) {
    0 => 1.0,
    1 => -0.5,
    _ => -1.5 * factor,
  };

  return BoxShadow(
    color: baseColor.replaceOpacity(opacity),
    blurRadius: blur,
    offset: Offset(0, yOffset) * offsetFactor + offsetDelta,
    spreadRadius: spread,
    blurStyle: style,
  );
});

List<BoxShadow> mediumShadows({
  double elevation = 1.0,
  Color baseColor = Colors.black,
  double opacity = 0.05,
  BlurStyle style = BlurStyle.normal,
  Offset offsetDelta = Offset.zero,
  double offsetFactor = 1.0,
}) =>
    elevation <= 0.0
        ? []
        : List.generate(6, (index) {
          final blur =
              index == 0 ? 0.0 : pow(2, index - 1).toDouble() * elevation;
          final yOffset = blur;
          final spread = switch (index) {
            0 => 1.0,
            _ => 0.0,
          };
          return BoxShadow(
            color: baseColor.replaceOpacity(opacity),
            blurRadius: blur,
            offset: Offset(0, yOffset) * offsetFactor + offsetDelta,
            spreadRadius: spread,
            blurStyle: style,
          );
        });

List<BoxShadow> broadShadows(
  BuildContext context, {
  double elevation = 1.0,
  Color? baseColor,
  BlurStyle style = BlurStyle.normal,
}) {
  if (elevation < 0.0) {
    return [];
  }
  final theme = ShadTheme.of(context);
  final Color color =
      baseColor ??
      theme.resolveColor(
        PColors.gray.color,
        const Color.fromARGB(255, 27, 27, 27),
      );
  return [
    BoxShadow(
      color: color.withOpacityFactor(min(2.0, 0.3 * elevation)),
      blurRadius: 16.0 * elevation,
      blurStyle: style,
    ),
  ];
}

Decoration broadShadowsCard(
  BuildContext context, {
  double cornerRadius = 12.0,
  BorderSide side = BorderSide.none,
}) => ShapeDecoration(
  shape: Superellipse(cornerRadius: cornerRadius, side: side),
  color: context.theme.colorScheme.card,
  shadows: broadShadows(context),
);
