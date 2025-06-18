import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/core.dart';

Future<T?> showPDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  Color barrierColor = const Color(0xcc000000),
  String barrierLabel = '',
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  ShadDialogVariant variant = ShadDialogVariant.primary,
  required WidgetBuilder builder,
}) => showShadDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  barrierColor: barrierColor,
  barrierLabel: barrierLabel,
  useRootNavigator: useRootNavigator,
  routeSettings: routeSettings,
  anchorPoint: anchorPoint,
  variant: variant,
  animateIn: [
    const SlideEffect(
      curve: Effects.snappyOutCurve,
      duration: Effects.shortDuration,
      begin: Offset(0.0, .1),
      end: Offset.zero,
    ),
    const FadeEffect(
      curve: Effects.snappyOutCurve,
      duration: Effects.shortDuration,
      begin: 0.0,
      end: 1.0,
    ),
    const ScaleEffect(
      curve: Effects.snappyOutCurve,
      duration: Effects.shortDuration,
      begin: Offset(0.5, 0.5),
      end: Offset(1.0, 1.0),
    ),
  ],
  animateOut: [
    const SlideEffect(
      curve: Effects.snappyOutCurve,
      duration: Effects.shortDuration,
      begin: Offset.zero,
      end: Offset(0.0, .05),
    ),
    const FadeEffect(
      curve: Effects.snappyOutCurve,
      duration: Effects.shortDuration,
      begin: 1.0,
      end: 0.0,
    ),
  ],
  builder: builder,
);
