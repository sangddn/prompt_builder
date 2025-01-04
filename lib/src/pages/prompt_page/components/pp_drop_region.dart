part of '../prompt_page.dart';

class _PPDropRegion extends StatefulWidget {
  const _PPDropRegion({required this.child});

  final Widget child;

  @override
  State<_PPDropRegion> createState() => _PPDropRegionState();
}

class _PPDropRegionState extends State<_PPDropRegion> {
  _ProcessingState _state = _ProcessingState.idle;

  Future<void> _performDrop(PerformDropEvent event) async {
    final readers = event.session.items.map((e) => e.dataReader).nonNulls;
    maybeSetState(() => _state = _ProcessingState.receiving);
    await context.handleDataReaders(readers.toList());
    maybeSetState(() => _state = _ProcessingState.received);
    Future.delayed(
            Effects.mediumDuration,
            () => maybeSetState(() => _state = _ProcessingState.idle),
          );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return DropRegion(
      formats: Formats.standardFormats,
      onDropOver: (event) {
        setState(() {
          _state = _ProcessingState.readyToReceive;
        });
        return DropOperation.copy;
      },
      onDropEnter: (event) {
        setState(() {
          _state = _ProcessingState.inviting;
        });
      },
      onDropLeave: (event) {
        if (_state != _ProcessingState.idle &&
            _state != _ProcessingState.received) {
          setState(() {
            _state = _ProcessingState.idle;
          });
        }
      },
      onPerformDrop: _performDrop,
      child: Stack(
        children: [
          widget.child,
          if (!_state.isIdle)
            Positioned.fill(
              left: 16.0,
              child: Builder(
                builder: (context) {
                  final text = _state.isReceived
                      ? 'Added!'
                      : _state.isReceiving
                          ? 'Adding...'
                          : 'Drop anything';
                  return AnimatedContainer(
                    duration: Effects.shortDuration,
                    curve: Curves.easeInOut,
                    color: (_state.isInviting
                        ? theme.resolveColor(Colors.white38, Colors.black38)
                        : theme.resolveColor(Colors.white54, Colors.black54)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TranslationSwitcher.top(
                          duration: Effects.veryShortDuration,
                          child: Text(
                            text,
                            style: context.textTheme.h3,
                            key: ValueKey(text),
                          ),
                        ),
                        const Gap(4.0),
                        if (_state.isInviting || _state.isReadyToReceive)
                          const Text('Drop files or folders to add to prompt.'),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

enum _ProcessingState {
  idle,
  inviting,
  readyToReceive,
  receiving,
  received,
  ;

  bool get isIdle => this == _ProcessingState.idle;
  bool get isInviting => this == _ProcessingState.inviting;
  bool get isReadyToReceive => this == _ProcessingState.readyToReceive;
  bool get isReceiving => this == _ProcessingState.receiving;
  bool get isReceived => this == _ProcessingState.received;
}
