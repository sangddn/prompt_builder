import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/core.dart';
import '../components.dart';

class TileButton extends StatelessWidget {
  const TileButton({
    this.additionalInfo,
    this.subtitleWhenEnabled,
    this.disabledText,
    this.trailing = const CupertinoListTileChevron(),
    this.enableBlurredBackground = false,
    this.leading,
    this.decoration,
    this.padding = k16H8VPadding,
    required this.title,
    required this.onPressed,
    super.key,
  }) : assert(decoration is ShapeDecoration? || decoration is BoxDecoration?);

  final EdgeInsets padding;
  final Widget? subtitleWhenEnabled;
  final String? disabledText;
  final Widget? additionalInfo;
  final Widget? trailing;
  final bool enableBlurredBackground;
  final Widget title;
  final Widget? leading;
  final Decoration? decoration;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDisabled = onPressed == null;
    final disabledColor = theme.colorScheme.foreground.replaceOpacity(0.5);

    return AnimatedDefaultTextStyle(
      duration: Effects.shortDuration,
      curve: Easing.emphasizedDecelerate,
      style: TextStyle(
        color: isDisabled ? disabledColor : theme.colorScheme.foreground,
      ),
      child: Builder(
        builder: (context) {
          final foregroundColor = DefaultTextStyle.of(context).style.color;
          final title = IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: DefaultTextStyle(
              style: TextStyle(color: foregroundColor),
              child: this.title,
            ),
          );
          final leading =
              this.leading != null
                  ? IconTheme(
                    data: IconThemeData(color: foregroundColor),
                    child: DefaultTextStyle(
                      style: TextStyle(color: foregroundColor),
                      child: this.leading!,
                    ),
                  )
                  : null;
          final tile = CupertinoListTile.notched(
            backgroundColor: theme.colorScheme.background.replaceOpacity(0.9),
            padding: padding,
            leading: leading,
            title: title,
            subtitle:
                isDisabled &&
                        disabledText != null &&
                        foregroundColor == disabledColor
                    ? Text(
                      disabledText!,
                      style: TextStyle(color: foregroundColor),
                    ).animate().fadeIn()
                    : subtitleWhenEnabled,
            trailing: trailing,
            additionalInfo:
                additionalInfo != null
                    ? DefaultTextStyle(
                      style: theme.textTheme.p.copyWith(
                        color: PColors.darkGray.resolveFrom(context),
                      ),
                      child: additionalInfo ?? const SizedBox(),
                    )
                    : null,
            onTap: onPressed,
          );

          final tileWithBackground =
              enableBlurredBackground
                  ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: tile,
                  )
                  : tile;

          final effectiveDecoration =
              decoration ??
              ShapeDecoration(
                color: theme.colorScheme.card.replaceOpacity(
                  enableBlurredBackground ? 0.0 : 1.0,
                ),
                shape: Superellipse.border12,
                shadows: broadShadows(context, elevation: 0.05),
              );

          final shape = switch (effectiveDecoration) {
            ShapeDecoration() => effectiveDecoration.shape,
            BoxDecoration() => switch (effectiveDecoration.shape) {
              BoxShape.circle => const CircleBorder(),
              BoxShape.rectangle => RoundedRectangleBorder(
                borderRadius:
                    effectiveDecoration.borderRadius ?? BorderRadius.zero,
              ),
            },
            _ => null,
          };

          return AnimatedContainer(
            duration: Effects.veryShortDuration,
            decoration: effectiveDecoration,
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              shape: shape,
              clipBehavior: Clip.antiAlias,
              child: tileWithBackground,
            ),
          );
        },
      ),
    );
  }
}
