part of 'file_tree.dart';

enum _ItemHoverState {
  none,
  hover,
  longHover,
  ;

  bool get isSimpleHover => this == _ItemHoverState.hover;
  bool get isLongHover => this == _ItemHoverState.longHover;
}

class _ItemPreviewer extends StatefulWidget {
  const _ItemPreviewer({required this.child});

  final Widget child;

  @override
  State<_ItemPreviewer> createState() => _ItemPreviewerState();
}

class _ItemPreviewerState extends State<_ItemPreviewer> {
  late final OverlayPortalController _controller;
  var _hoverState = _ItemHoverState.none;

  @override
  void initState() {
    super.initState();
    _controller = OverlayPortalController();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (context) {
        return const SizedBox();
      },
      child: LongHoverButton(
        onHover: (_) => setState(() => _hoverState = _ItemHoverState.hover),
        onExit: (_) => setState(() => _hoverState = _ItemHoverState.none),
        onLongHover: (_) {
          setState(() => _hoverState = _ItemHoverState.longHover);
          _controller.show();
        },
        child: Provider<_ItemHoverState>.value(
          value: _hoverState,
          child: widget.child,
        ),
      ),
    );
  }
}

extension _HoverStateExtension on BuildContext {
  _ItemHoverState watchHoverState() => watch();
  bool isSimpleHovered() => watchHoverState().isSimpleHover;
  bool isLongHovered() => watchHoverState().isLongHover;
  bool isSimpleOrLongHovered() => isSimpleHovered() || isLongHovered();
}
