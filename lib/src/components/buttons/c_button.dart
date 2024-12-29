import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../components.dart';

class CButton extends StatelessWidget {
  const CButton({
    this.padding = EdgeInsets.zero,
    this.color,
    this.side = BorderSide.none,
    this.cornerRadius = 8.0,
    this.clipBehavior = Clip.antiAlias,
    this.pressedOpacity = 0.4,
    this.tooltipTriggerMode = TooltipTriggerMode.longPress,
    this.tooltipPreferBelow,
    this.focusNode,
    this.addFeedback = false,
    this.mouseCursor = SystemMouseCursors.basic,
    required this.tooltip,
    required this.onTap,
    required this.child,
    super.key,
  }) : assert(tooltip is String? || tooltip is InlineSpan?);

  final EdgeInsetsGeometry padding;
  final BorderSide side;
  final double cornerRadius;
  final double pressedOpacity;
  final Color? color;
  final TooltipTriggerMode tooltipTriggerMode;
  final bool? tooltipPreferBelow;
  final FocusNode? focusNode;
  final bool addFeedback;
  /// The tooltip to show when the button is pressed.
  ///
  /// Can be a [String]? or an [InlineSpan]?.
  ///
  final dynamic tooltip;
  final MouseCursor? mouseCursor;
  final Clip clipBehavior;
  final VoidCallback? onTap;
  final Widget child;

  void _callback() {
    return onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<FocusNode>(
      create: (_) => focusNode ?? FocusNode(),
      builder: (context, child) {
        final hasFocus = context.watch<FocusNode>().hasFocus;
        final extraPadding = hasFocus ? 1.5 : 0.0;
        return AnimatedContainer(
          duration: Effects.shortDuration,
          curve: Curves.ease,
          decoration: ShapeDecoration(
            shape: Superellipse(
              side: side.copyWith(
                color: Colors.blueAccent,
                width: side.width * 2.0,
              ),
              cornerRadius: cornerRadius + extraPadding - 0.5,
            ),
          ),
          padding: EdgeInsets.all(extraPadding),
          clipBehavior: clipBehavior,
          child: Material(
            color: Colors.transparent,
            shape: Superellipse(cornerRadius: cornerRadius),
            clipBehavior: clipBehavior,
            child: InkResponse(
              mouseCursor: mouseCursor,
              onTap: onTap == null ? null : () {},
              splashColor: Colors.transparent,
              highlightShape: BoxShape.rectangle,
              hoverColor: PColors.lightGray.resolveFrom(context),
              canRequestFocus: false,
              child: CupertinoButton(
                color: color,
                padding: padding,
                minSize: 0.0,
                pressedOpacity: pressedOpacity,
                borderRadius: BorderRadius.circular(cornerRadius),
                focusNode: context.read(),
                focusColor: context.colorScheme.selection,
                onPressed: onTap == null
                    ? null
                    : addFeedback
                        ? () {
                            Feedback.wrapForTap(_callback, context)?.call();
                          }
                        : _callback,
                child: PTooltip(
                  message: tooltip is String? ? tooltip as String? : null,
                  richMessage:
                      tooltip is InlineSpan? ? tooltip as InlineSpan? : null,
                  triggerMode: tooltipTriggerMode,
                  preferBelow: tooltipPreferBelow,
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}
