import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../components.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    this.isSelected = false,
    this.leading,
    this.trailing,
    this.padding,
    this.subtitle,
    this.shape,
    this.isDestructive = false,
    this.leadingGap,
    this.trailingGap,
    required this.title,
    required this.onPressed,
    super.key,
  });

  final bool isSelected, isDestructive;
  final EdgeInsetsGeometry? padding;
  final double? leadingGap, trailingGap;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;
  final ShapeBorder? shape;
  final Widget title;
  final VoidCallback? onPressed;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _isHovering = false, _isPressing = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final menuButtonTheme = PMenuButtonTheme.of(context);
    final destructiveColor = CupertinoColors.systemRed.resolveFrom(context);

    final Color backgroundColor = _isPressing || _isHovering
        ? Colors.transparent
        : widget.isSelected
            ? menuButtonTheme.selectedBackgroundColor ??
                PColors.gray.resolveFrom(context)
            : menuButtonTheme.backgroundColor ?? Colors.transparent;

    final ShapeBorder shape =
        widget.shape ?? menuButtonTheme.shape ?? Superellipse.border12;

    final Color iconColor = widget.isSelected || _isHovering
        ? menuButtonTheme.selectedIconColor ??
            (widget.isDestructive
                ? destructiveColor
                : theme.colorScheme.foreground)
        : menuButtonTheme.iconColor ??
            (widget.isDestructive
                ? destructiveColor
                : PColors.textGray.resolveFrom(context));

    final TextStyle titleStyle = widget.isSelected || _isHovering
        ? menuButtonTheme.selectedTextStyle ??
            theme.textTheme.p.copyWith(
              color: widget.isDestructive
                  ? destructiveColor
                  : theme.colorScheme.foreground,
            )
        : menuButtonTheme.titleStyle ??
            theme.textTheme.p.copyWith(
              color: PColors.textGray.resolveFrom(context),
              fontWeight: FontWeight.w500,
            );

    final TextStyle subtitleStyle = widget.isSelected || _isHovering
        ? menuButtonTheme.selectedSubtitleStyle ??
            theme.textTheme.small.copyWith(
              color: widget.isDestructive
                  ? destructiveColor
                  : theme.colorScheme.foreground.withOpacityFactor(0.8),
            )
        : menuButtonTheme.subtitleStyle ??
            theme.textTheme.small.copyWith(
              color: widget.isDestructive
                  ? destructiveColor
                  : PColors.darkGray.resolveFrom(context),
            );

    final EdgeInsetsGeometry padding =
        widget.padding ?? menuButtonTheme.padding ?? k16H4VPadding;

    final iconTheme = TextStyle(
      color: widget.isDestructive ? destructiveColor : iconColor,
      fontSize: theme.textTheme.h3.fontSize?.let((s) => s - 3.0),
    );

    Widget wrapAnimTheme(Widget child) => AnimatedDefaultTextStyle(
          duration: Effects.veryShortDuration,
          style: iconTheme,
          child: Builder(
            builder: (context) {
              final TextStyle style = DefaultTextStyle.of(context).style;
              final Color iconColor = style.color!;
              final double iconSize = style.fontSize!;
              return IconTheme(
                data: IconThemeData(
                  color: iconColor,
                  size: iconSize,
                ),
                child: child,
              );
            },
          ),
        );

    return AnimatedContainer(
      duration: Effects.veryShortDuration,
      curve: Easing.emphasizedDecelerate,
      decoration: ShapeDecoration(
        shape: shape,
        color: backgroundColor,
      ),
      child: AnimatedOpacity(
        duration: Effects.veryShortDuration,
        opacity: widget.onPressed == null ? 0.5 : 1.0,
        child: BouncingObject(
          onTap: () {},
          onAnimation: (controller) {},
          child: Material(
            color: Colors.transparent,
            shape: shape,
            clipBehavior: Clip.antiAlias,
            child: InkResponse(
              onTap: widget.onPressed == null
                  ? null
                  : () {
                      widget.onPressed?.call();
                    },
              onHover: (isHovering) {
                setState(() => _isHovering = isHovering);
              },
              onTapDown: (_) => setState(() => _isPressing = true),
              onTapCancel: () => setState(() => _isPressing = false),
              onTapUp: (_) {
                setState(() => _isPressing = false);
                scheduleMicrotask(
                  context.read<ActiveContextMenu?>()?.hide ?? () {},
                );
              },
              highlightShape: BoxShape.rectangle,
              // highlightColor: Colors.transparent,
              // focusColor: Colors.transparent,
              // hoverColor: Colors.transparent,
              // splashColor: Colors.transparent,
              // overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              child: Padding(
                padding: padding,
                child: Row(
                  children: [
                    if (widget.leading case final leading?)
                      wrapAnimTheme(leading),
                    Gap(
                      widget.leadingGap ??
                          min(4.0, padding.horizontal / 2 - 2.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: Effects.veryShortDuration,
                            style: titleStyle,
                            child: widget.title,
                          ),
                          if (widget.subtitle case final subtitle?)
                            AnimatedDefaultTextStyle(
                              duration: Effects.veryShortDuration,
                              style: subtitleStyle,
                              child: subtitle,
                            ),
                        ],
                      ),
                    ),
                    if (widget.trailing case final trailing?) ...[
                      Gap(
                        widget.trailingGap ??
                            min(4.0, padding.horizontal / 2 - 4.0),
                      ),
                      wrapAnimTheme(trailing),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PMenuButtonTheme extends InheritedWidget {
  const PMenuButtonTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final PMenuButtonThemeData data;

  static PMenuButtonThemeData of(BuildContext context) {
    final PMenuButtonTheme? menuButtonTheme =
        context.dependOnInheritedWidgetOfExactType<PMenuButtonTheme>();
    return menuButtonTheme?.data ?? const PMenuButtonThemeData();
  }

  @override
  bool updateShouldNotify(PMenuButtonTheme oldWidget) {
    return data != oldWidget.data;
  }
}

@immutable
class PMenuButtonThemeData {
  const PMenuButtonThemeData({
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.iconColor,
    this.selectedBackgroundColor,
    this.selectedTextStyle,
    this.selectedSubtitleStyle,
    this.selectedIconColor,
    this.shape,
    this.padding,
  });

  final Color? backgroundColor,
      selectedBackgroundColor,
      iconColor,
      selectedIconColor;
  final TextStyle? titleStyle,
      subtitleStyle,
      selectedTextStyle,
      selectedSubtitleStyle;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? padding;

  PMenuButtonThemeData copyWith({
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Color? iconColor,
    Color? selectedBackgroundColor,
    Color? selectedIconColor,
    TextStyle? selectedTextStyle,
    TextStyle? selectedSubtitleStyle,
    ShapeBorder? shape,
    EdgeInsetsGeometry? padding,
  }) {
    return PMenuButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      iconColor: iconColor ?? this.iconColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      selectedSubtitleStyle:
          selectedSubtitleStyle ?? this.selectedSubtitleStyle,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PMenuButtonThemeData &&
        other.backgroundColor == backgroundColor &&
        other.titleStyle == titleStyle &&
        other.subtitleStyle == subtitleStyle &&
        other.iconColor == iconColor &&
        other.selectedBackgroundColor == selectedBackgroundColor &&
        other.selectedTextStyle == selectedTextStyle &&
        other.selectedSubtitleStyle == selectedSubtitleStyle &&
        other.selectedIconColor == selectedIconColor &&
        other.shape == shape &&
        other.padding == padding;
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      titleStyle,
      subtitleStyle,
      iconColor,
      selectedBackgroundColor,
      selectedTextStyle,
      selectedSubtitleStyle,
      selectedIconColor,
      shape,
      padding,
    );
  }
}
