import 'dart:math';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/core.dart';
import '../components.dart';

enum DialogTransition {
  fadeSlide,
  fadeScale,
  ;

  Widget Function(Animation<double>, Widget) get builder => switch (this) {
        DialogTransition.fadeSlide => _slideFadeTransitionBuilder,
        DialogTransition.fadeScale => _fadeScaleInTransitionBuilder,
      };
}

Future<T?> showPDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  EdgeInsetsGeometry padding = k24HPadding,
  bool isDismissible = true,
  double? maxHeight,
  double? maxWidth,
  double? elevation,
  BoxConstraints? dialogContraints,
  Color? barrierColor,
  bool useRootNavigator = false,
  double backgroundOpacity = 1.0,
  DialogTransition transition = DialogTransition.fadeSlide,
}) =>
    showGeneralDialog<T>(
      context: context,
      barrierColor: barrierColor ?? Colors.transparent,
      barrierDismissible: isDismissible,
      barrierLabel: 'Dismiss',
      useRootNavigator: useRootNavigator,
      transitionDuration: Effects.shortDuration,
      pageBuilder: (context, anim1, anim2) => transition.builder(
        anim1,
        _DialogWrapper(
          elevation: elevation,
          backgroundOpacity: backgroundOpacity,
          padding: padding,
          isDismissible: isDismissible,
          maxHeightPercentage: maxHeight,
          maxWidthPercentage: maxWidth,
          childConstraints: dialogContraints,
          child: builder(context),
        ),
      ),
    );

Widget _slideFadeTransitionBuilder(
  Animation<double> animation,
  Widget child,
) {
  // Apply Curves.easeInOut to the animation for a smooth transition.
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Easing.emphasizedDecelerate,
  );

  final slideTween = Tween<Offset>(
    begin: const Offset(0, 1), // Start from bottom
    end: Offset.zero, // End at current position
  );

  return SlideTransition(
    position:
        slideTween.animate(curvedAnimation), // Slide up animation with curve
    child: FadeTransition(
      opacity: curvedAnimation, // Fade in animation with curve
      child: child,
    ),
  );
}

Widget _fadeScaleInTransitionBuilder(
  Animation<double> animation,
  Widget child,
) {
  // Apply Curves.easeInOut to the animation for a smooth transition.
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Easing.emphasizedDecelerate,
  );

  final scaleTween = Tween<double>(
    begin: 1.2, // Start from 1.2
    end: 1.0, // End at 1
  );

  return ScaleTransition(
    scale: scaleTween.animate(curvedAnimation), // Scale in animation with curve
    child: FadeTransition(
      opacity: curvedAnimation, // Fade in animation with curve
      child: child,
    ),
  );
}

class _DialogWrapper extends StatelessWidget {
  const _DialogWrapper({
    required this.backgroundOpacity,
    required this.padding,
    required this.isDismissible,
    required this.maxHeightPercentage,
    required this.maxWidthPercentage,
    required this.childConstraints,
    required this.elevation,
    required this.child,
  });

  final double backgroundOpacity;
  final EdgeInsetsGeometry padding;
  final bool isDismissible;
  final double? maxHeightPercentage, maxWidthPercentage, elevation;
  final BoxConstraints? childConstraints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ReTheme(
      includeNewScaffoldMessenger: true,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barrierColor =
                  theme.colorScheme.onSurface.replaceOpacity(0.2);

              return Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: isDismissible
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: ColoredBox(
                        color: barrierColor,
                      ),
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: min(
                          constraints.maxWidth * (maxWidthPercentage ?? 0.9),
                          childConstraints?.maxWidth ?? 1200.0,
                        ),
                        maxHeight: min(
                          constraints.maxHeight * (maxHeightPercentage ?? 0.9),
                          childConstraints?.maxHeight ?? double.infinity,
                        ),
                      ),
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: Superellipse(
                            cornerRadius: 24.0,
                            side: BorderSide(
                              color: theme.colorScheme.onSurface
                                  .replaceOpacity(0.2),
                            ),
                          ),
                          color: theme.scaffoldBackgroundColor
                              .withOpacityFactor(backgroundOpacity),
                          shadows: broadShadows(
                            context,
                            elevation: elevation ?? 16.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        padding: padding,
                        child: child,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
