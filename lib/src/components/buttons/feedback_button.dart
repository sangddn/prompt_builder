import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/core.dart';
import '../components.dart';

/// A button that provides explicit, separate feedback to the user when pressed.
///
/// When pressed, the feedback animates from behind of the button up, down,
/// left or right.
///
class FeedbackButton<T> extends StatefulWidget {
  const FeedbackButton({
    this.overlayController,
    this.feedbackPosition,
    this.timeToLive = const Duration(milliseconds: 1500),
    required this.feedbackBuilder,
    required this.builder,
    super.key,
  });

  final OverlayPortalController? overlayController;

  final AxisDirection Function(
    bool isInTopHalfOfScreen,
    bool isInStartHalfOfScreen,
  )?
  feedbackPosition;

  final Duration timeToLive;

  /// The feedback builder that will be shown when the button is pressed.
  ///
  /// Typically returns a [DefaultFeedbackOverlay].
  ///
  final Widget Function(
    BuildContext context,
    VoidCallback hideFeedback,
    T? isSuccess,
  )
  feedbackBuilder;

  /// Builds the button that will be shown to the user.
  ///
  /// The [showFeedback] callback should be called when the button is pressed and
  /// passed the success state of the action.
  /// If true, [Haptics.success()] will be called.
  /// If false, [Haptics.error()] will be called.
  ///
  final Widget Function(BuildContext context, ValueChanged<T?> showFeedback)
  builder;

  @override
  State<FeedbackButton<T>> createState() => _FeedbackButtonState<T>();
}

class _FeedbackButtonState<T> extends State<FeedbackButton<T>>
    with SingleTickerProviderStateMixin {
  T? _isSuccess;
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

  void _show(T? isSuccess) {
    _isSuccess = isSuccess;
    _overlayController.show();
    _animationController.forward().then(
      (value) => Future.delayed(widget.timeToLive, () {
        if (mounted && _animationController.isCompleted) {
          _hide();
        }
      }),
    );
  }

  void _hide() {
    _animationController.reverse().then((_) {
      if (mounted) {
        _overlayController.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (overlayContext) {
        final button = context.findRenderObject()! as RenderBox;
        final overlay =
            Navigator.of(context).overlay!.context.findRenderObject()!
                as RenderBox;

        late final Size childSize = button.size;

        late final Offset childPosition;
        final childPositionInRoot = button.localToGlobal(Offset.zero);
        final childPositionInOverlay = overlay.globalToLocal(
          childPositionInRoot,
        );
        childPosition = childPositionInOverlay;

        final overlayContextSize = overlay.size;
        final height = overlayContextSize.height;
        final width = overlayContextSize.width;

        final isInTopHalf = childPosition.dy < height / 2;
        final isInStartHalf = childPosition.dx < width / 2;

        final desiredPosition = widget.feedbackPosition?.call(
          isInTopHalf,
          isInStartHalf,
        );

        final shouldShowAbove =
            desiredPosition?.isAbove() ?? childPosition.dy > height / 2;
        final shouldShowBelow =
            desiredPosition?.isBelow() ?? childPosition.dy <= height / 2;
        final shouldShowVertical = shouldShowAbove || shouldShowBelow;
        final shouldShowStart =
            desiredPosition?.isStart(context) ??
            (!shouldShowVertical && childPosition.dx > width / 2);
        final shouldShowEnd =
            desiredPosition?.isEnd(context) ??
            (!shouldShowVertical && childPosition.dx <= width / 2);
        // final shouldShowHorizontal = shouldShowStart || shouldShowEnd;

        final endOfButton = width - childPosition.dx - childSize.width;
        final startOfButton = childPosition.dx;
        final topOfButton = childPosition.dy;
        final bottomOfButton = height - childPosition.dy - childSize.height;

        final minVertical = min(topOfButton, bottomOfButton);
        final minHorizontal = min(startOfButton, endOfButton);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (_) => _hide(),
              ),
            ),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              top:
                  shouldShowAbove
                      ? 0.0
                      : shouldShowBelow
                      ? topOfButton + childSize.height
                      : topOfButton - minVertical,
              bottom:
                  shouldShowBelow
                      ? 0.0
                      : shouldShowAbove
                      ? bottomOfButton + childSize.height
                      : bottomOfButton - minVertical,
              start:
                  shouldShowStart
                      ? 0.0
                      : shouldShowEnd
                      ? startOfButton + childSize.width
                      : startOfButton - minHorizontal,
              end:
                  shouldShowEnd
                      ? 0.0
                      : shouldShowStart
                      ? endOfButton + childSize.width
                      : endOfButton - minHorizontal,
              child: Align(
                alignment:
                    shouldShowAbove
                        ? Alignment.bottomCenter
                        : shouldShowBelow
                        ? Alignment.topCenter
                        : shouldShowStart
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                child: IconTheme(
                  data: theme.iconTheme.copyWith(size: 20.0),
                  child: Container(
                        decoration: ShapeDecoration(
                          shape: const SquircleStadiumBorder(),
                          color: context.colorScheme.secondary,
                          shadows: focusedShadows(),
                        ),
                        padding: k8VPadding + k8HPadding,
                        margin: k16H8VPadding,
                        // width: 600.0,
                        child: Material(
                          color: Colors.transparent,
                          shape: Superellipse.border12,
                          clipBehavior: Clip.antiAlias,
                          child: widget.feedbackBuilder(
                            context,
                            _hide,
                            _isSuccess,
                          ),
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
                      .scale(
                        duration: Effects.veryShortDuration,
                        curve: Easing.emphasizedDecelerate,
                        end: const Offset(1.0, 1.0),
                        begin:
                            shouldShowVertical
                                ? const Offset(0.5, 0.8)
                                : const Offset(0.8, 0.5),
                      )
                      .slide(
                        duration: Effects.veryShortDuration,
                        curve: Easing.emphasizedDecelerate,
                        end: Offset.zero,
                        begin:
                            shouldShowVertical
                                ? shouldShowAbove
                                    ? const Offset(0.0, 1.0)
                                    : const Offset(0.0, -1.0)
                                : shouldShowStart
                                ? const Offset(1.0, 0.0)
                                : const Offset(-1.0, 0.0),
                      ),
                ),
              ),
            ),
          ],
        );
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: (1.0 - _animationController.value).clamp(0.2, 1.0),
            child: child,
          );
        },
        child: widget.builder(context, _show),
      ),
    );
  }
}

extension _AxisDirectionX on AxisDirection {
  bool isAbove() => this == AxisDirection.up;
  bool isBelow() => this == AxisDirection.down;
  bool isStart(BuildContext context) =>
      (this == AxisDirection.left &&
          Directionality.of(context) == TextDirection.ltr) ||
      (this == AxisDirection.right &&
          Directionality.of(context) == TextDirection.rtl);
  bool isEnd(BuildContext context) =>
      !isStart(context) && !isBelow() && !isAbove();
}
