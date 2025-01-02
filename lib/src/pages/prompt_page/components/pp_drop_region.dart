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
    for (final reader in readers) {
      if (reader.canProvide(Formats.fileUri)) {
        reader.getValue(Formats.fileUri, (value) async {
          if (mounted && value != null) {
            await _handleNodeSelection(
              context,
              reloadNode: true,
              fullPath: value.toFilePath(),
              isSelected: true,
            );
            maybeSetState(() => _state = _ProcessingState.received);
            Future.delayed(
              Effects.mediumDuration,
              () => maybeSetState(() => _state = _ProcessingState.idle),
            );
          }
        });
      }
    }
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
                            _state.isReceived ? 'Added!' : 'Drop anything',
                            style: context.textTheme.h3,
                            key: ValueKey(_state.isReceived),
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
  received,
  ;

  bool get isIdle => this == _ProcessingState.idle;
  bool get isInviting => this == _ProcessingState.inviting;
  bool get isReadyToReceive => this == _ProcessingState.readyToReceive;
  bool get isReceived => this == _ProcessingState.received;
}
