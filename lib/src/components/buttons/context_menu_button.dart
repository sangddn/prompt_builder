import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../components.dart';

enum FeedbackOverlayPosition {
  aboveStart,
  aboveEnd,
  belowStart,
  belowEnd,
  start,
  end,
  above,
  below,
  ;

  bool get isAbove => this == FeedbackOverlayPosition.above;
  bool get isStart => this == FeedbackOverlayPosition.start;
  bool get isEnd => this == FeedbackOverlayPosition.end;
  bool get isBelow => this == FeedbackOverlayPosition.below;
  bool get isAboveStart => this == FeedbackOverlayPosition.aboveStart;
  bool get isAboveEnd => this == FeedbackOverlayPosition.aboveEnd;
  bool get isBelowStart => this == FeedbackOverlayPosition.belowStart;
  bool get isBelowEnd => this == FeedbackOverlayPosition.belowEnd;

  bool get isGenerallyAbove => isAbove || isAboveStart || isAboveEnd;
  bool get isGenerallyBelow => isBelow || isBelowStart || isBelowEnd;
  bool get isGenerallyStart => isStart || isAboveStart || isBelowStart;
  bool get isGenerallyEnd => isEnd || isAboveEnd || isBelowEnd;
}

final class ActiveContextMenu {
  const ActiveContextMenu({
    required this.show,
    required this.hide,
  });

  final VoidCallback show;
  final VoidCallback hide;
}

class ContextMenuButton extends StatefulWidget {
  const ContextMenuButton({
    this.overlayController,
    this.overlayPosition,
    required this.items,
    required this.builder,
    super.key,
  });

  final OverlayPortalController? overlayController;

  final FeedbackOverlayPosition Function(
    bool isInTopHalfOfScreen,
    bool isInStartHalfOfScreen,
  )? overlayPosition;

  /// The list of items to show in the context menu.
  ///
  /// Typically a list of [MenuButton].
  ///
  final List<Widget> items;
  final Widget Function(BuildContext context, VoidCallback showMenu) builder;

  @override
  State<ContextMenuButton> createState() => _ContextMenuButtonState();
}

class _ContextMenuButtonState extends State<ContextMenuButton>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: Effects.veryShortDuration,
  );
  late final _overlayController =
      widget.overlayController ?? OverlayPortalController();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _show() {
    _overlayController.show();
    _animationController.forward();
  }

  void _hide() {
    _animationController.reverse().then(
          (value) => _overlayController.hide(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final direction = Directionality.of(context);
    final leftToRight = direction == TextDirection.ltr;

    final menu = IntrinsicWidth(
      child: PMenuButtonTheme(
        data: PMenuButtonThemeData(
          padding: k16H8VPadding,
          titleStyle: theme.textTheme.p,
          subtitleStyle: theme.textTheme.small,
          shape: Superellipse.border12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.items,
        ),
      ),
    );

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (overlayContext) {
        final button = context.findRenderObject()! as RenderBox;
        final overlay = Navigator.of(context)
            .overlay!
            .context
            .findRenderObject()! as RenderBox;

        late final Size childSize = button.size;

        late final Offset childPosition;
        final childPositionInRoot = button.localToGlobal(Offset.zero);
        final childPositionInOverlay =
            overlay.globalToLocal(childPositionInRoot);
        childPosition = childPositionInOverlay;

        final overlayContextSize = overlay.size;
        final height = overlayContextSize.height;
        final width = overlayContextSize.width;

        final isInTopHalf = childPosition.dy < height / 2;
        final isInStartHalf = childPosition.dx < width / 2;

        final desiredPosition = widget.overlayPosition?.call(
          isInTopHalf,
          isInStartHalf,
        );

        final shouldShowAbove =
            desiredPosition?.isGenerallyAbove ?? childPosition.dy > height / 2;
        final shouldShowBelow =
            desiredPosition?.isGenerallyBelow ?? childPosition.dy <= height / 2;
        final shouldBeVerticallyCentered = !shouldShowAbove && !shouldShowBelow;
        final shouldShowStart =
            desiredPosition?.isGenerallyStart ?? childPosition.dx > width / 2;
        final shouldShowEnd =
            desiredPosition?.isGenerallyEnd ?? childPosition.dx <= width / 2;
        final shouldBeHorizontallyCentered = !shouldShowStart && !shouldShowEnd;

        return Provider.value(
          value: ActiveContextMenu(show: _show, hide: _hide),
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(onTap: _hide),
              ),
              Positioned.directional(
                top: shouldShowAbove
                    ? null
                    : childPosition.dy +
                        (shouldBeVerticallyCentered
                            ? 0.0
                            : (childSize.height + 8.0)),
                bottom: shouldShowAbove
                    ? height -
                        childPosition.dy +
                        (shouldBeVerticallyCentered ? 0.0 : 8.0)
                    : null,
                start: shouldShowStart
                    ? null
                    : childPosition.dx +
                        (shouldBeHorizontallyCentered
                            ? 0.0
                            : (childSize.width + 8.0)),
                end: shouldShowStart
                    ? width -
                        (childPosition.dx +
                            (shouldBeHorizontallyCentered
                                ? childSize.width / 2
                                : -8.0))
                    : null,
                textDirection: direction,
                child: Container(
                  decoration: ShapeDecoration(
                    color: overlayContext.colorScheme.card,
                    shape: Superellipse.border12,
                    shadows: broadShadows(context),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: Material(
                    color: Colors.transparent,
                    shape: Superellipse.border12,
                    clipBehavior: Clip.antiAlias,
                    child: menu,
                  ),
                )
                    .animate(
                      autoPlay: false,
                      controller: _animationController,
                    )
                    .fadeIn(
                      duration: Effects.veryShortDuration,
                      curve: Easing.emphasizedDecelerate,
                    )
                    .scaleXY(
                      duration: Effects.veryShortDuration,
                      curve: Easing.emphasizedDecelerate,
                      begin: 0.0,
                      end: 1.0,
                      alignment: leftToRight
                          ? shouldShowAbove
                              ? shouldShowStart
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft
                              : shouldShowStart
                                  ? Alignment.topRight
                                  : Alignment.topLeft
                          : shouldShowAbove
                              ? shouldShowStart
                                  ? Alignment.bottomLeft
                                  : Alignment.bottomRight
                              : shouldShowStart
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                    ),
              ),
            ],
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: (1.0 - _animationController.value).clamp(0.2, 1.0),
            child: widget.builder(
              context,
              _show,
            ),
          );
        },
      ),
    );
  }
}
