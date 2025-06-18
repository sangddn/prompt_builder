import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

class PTooltip extends StatefulWidget {
  const PTooltip({
    required this.child,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.message,
    this.richMessage,
    this.preferBelow,
    this.toolTipKey,
    super.key,
  }) : assert(
         !(message != null && richMessage != null),
         'Only one of message or richMessage can be provided',
       );

  final TooltipTriggerMode triggerMode;
  final String? message;
  final InlineSpan? richMessage;
  final bool? preferBelow;
  final GlobalKey<TooltipState>? toolTipKey;
  final Widget child;

  @override
  State<PTooltip> createState() => _PTooltipState();
}

class _PTooltipState extends State<PTooltip> {
  final _key = GlobalKey<_PTooltipState>();

  @override
  Widget build(BuildContext context) {
    if (widget.message == null && widget.richMessage == null) {
      return KeyedSubtree(key: _key, child: widget.child);
    }
    return KeyedSubtree(
      key: _key,
      child: Tooltip(
        key: widget.toolTipKey,
        message: widget.message,
        richMessage: widget.richMessage,
        waitDuration: const Duration(milliseconds: 300),
        triggerMode: widget.triggerMode,
        preferBelow: widget.preferBelow,
        decoration: ShapeDecoration(
          color: context.colorScheme.muted,
          shape: Superellipse.border8,
          shadows: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: k16H12VPadding,
        textStyle:
            widget.richMessage != null
                ? null
                : context.theme.textTheme.small.copyWith(
                  color: context.colorScheme.mutedForeground,
                ),
        child: widget.child,
      ),
    );
  }
}
