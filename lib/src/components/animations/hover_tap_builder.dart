import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HoverTapBuilder extends StatefulWidget {
  const HoverTapBuilder({
    this.hoverColor,
    this.focusColor,
    this.highlightColor,
    this.hitTestBehavior = HitTestBehavior.deferToChild,
    this.onHoverOrTapEnter,
    this.onHoverOrTapExit,
    this.onClicked,
    required this.builder,
    super.key,
  });

  final Color? highlightColor, hoverColor, focusColor;
  final HitTestBehavior hitTestBehavior;
  final VoidCallback? onHoverOrTapEnter, onHoverOrTapExit;
  final VoidCallback? onClicked;
  final Widget Function(BuildContext context, bool isHovering) builder;

  @override
  State<HoverTapBuilder> createState() => _HoverTapBuilderState();
}

class _HoverTapBuilderState extends State<HoverTapBuilder> {
  bool _isHovering = false, _isMouse = false;

  void _onHoverOrTapEnter() {
    widget.onHoverOrTapEnter?.call();
    setState(() {
      _isHovering = true;
    });
  }

  void _onHoverOrTapExit() {
    widget.onHoverOrTapExit?.call();
    setState(() {
      _isHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: widget.hitTestBehavior,
      onEnter: (_) {
        _onHoverOrTapEnter();
        _isMouse = true;
      },
      onExit: (_) => _onHoverOrTapExit(),
      child: InkResponse(
        mouseCursor:
            widget.onClicked != null
                ? SystemMouseCursors.click
                : MouseCursor.defer,
        onTap: widget.onClicked,
        onTapDown: (_) => _isMouse ? null : _onHoverOrTapEnter(),
        onTapUp: (_) => _isMouse ? null : _onHoverOrTapExit(),
        onTapCancel: () => _isMouse ? null : _onHoverOrTapExit(),
        highlightColor: widget.highlightColor,
        hoverColor: widget.hoverColor,
        focusColor: widget.focusColor,
        highlightShape: BoxShape.rectangle,
        splashFactory: NoSplash.splashFactory,
        child: widget.builder(context, _isHovering),
      ),
    );
  }
}

class DisambiguatedHoverTapBuilder extends StatefulWidget {
  const DisambiguatedHoverTapBuilder({
    this.hitTestBehavior = HitTestBehavior.deferToChild,
    this.onHover,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onTap,
    required this.builder,
    super.key,
  });

  final HitTestBehavior hitTestBehavior;
  final ValueChanged<bool>? onHover;
  final VoidCallback? onTapDown, onTapUp, onTapCancel, onTap;

  final Widget Function(BuildContext context, bool isHovering, bool isPressing)
  builder;

  @override
  State<DisambiguatedHoverTapBuilder> createState() =>
      _DisambiguatedHoverTapBuilderState();
}

class _DisambiguatedHoverTapBuilderState
    extends State<DisambiguatedHoverTapBuilder> {
  bool _isHovering = false, _isPressing = false;

  void _onHover(bool isHovering) {
    widget.onHover?.call(isHovering);
    setState(() {
      _isHovering = isHovering;
    });
  }

  void _onTapDown() {
    widget.onTapDown?.call();
    setState(() {
      _isPressing = true;
    });
  }

  void _onTapUp() {
    widget.onTapUp?.call();
    setState(() {
      _isPressing = false;
    });
  }

  void _onTapCancel() {
    widget.onTapCancel?.call();
    setState(() {
      _isPressing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: widget.hitTestBehavior,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: () => _onTapCancel(),
        onTap: widget.onTap,
        child: widget.builder(context, _isHovering, _isPressing),
      ),
    );
  }
}

class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    this.hitTestBehavior,
    this.opaque = true,
    this.cursor = MouseCursor.defer,
    this.onEnter,
    this.onExit,
    this.onHover,
    required this.builder,
    super.key,
  });

  final HitTestBehavior? hitTestBehavior;
  final bool opaque;
  final MouseCursor cursor;
  final ValueChanged<PointerEnterEvent>? onEnter;
  final ValueChanged<PointerExitEvent>? onExit;
  final ValueChanged<PointerHoverEvent>? onHover;
  final Widget Function(BuildContext context, bool isHovering) builder;

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _isHovering = false;

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: widget.hitTestBehavior,
      opaque: widget.opaque,
      cursor: widget.cursor,
      onEnter: (event) {
        _onHover(true);
        widget.onEnter?.call(event);
      },
      onExit: (event) {
        _onHover(false);
        widget.onExit?.call(event);
      },
      onHover: widget.onHover,
      child: widget.builder(context, _isHovering),
    );
  }
}
