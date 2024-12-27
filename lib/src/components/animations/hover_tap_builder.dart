import 'package:flutter/material.dart';

class HoverTapBuilder extends StatefulWidget {
  const HoverTapBuilder({
    this.hitTestBehavior = HitTestBehavior.deferToChild,
    this.onHoverOrTapEnter,
    this.onHoverOrTapExit,
    this.onClicked,
    required this.builder,
    super.key,
  });

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
        mouseCursor: widget.onClicked != null
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        onTap: widget.onClicked,
        onTapDown: (_) => _isMouse ? null : _onHoverOrTapEnter(),
        onTapUp: (_) => _isMouse ? null : _onHoverOrTapExit(),
        onTapCancel: () => _isMouse ? null : _onHoverOrTapExit(),
        highlightShape: BoxShape.rectangle,
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
