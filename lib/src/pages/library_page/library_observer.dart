import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A top-level observer widget that manages notifications for new prompts added to the library.
///
/// This widget serves as an app-wide communication channel for notifying interested parties
/// when new prompts are added to the library. It uses Flutter's [Notification] system
/// combined with a listener pattern to propagate these events.
///
/// To listen for new prompts:
/// ```dart
/// final observer = context.read<LibraryObserverState>();
/// observer.addNewPromptListener((promptId) {
///   // Handle new prompt
/// });
/// ```
class LibraryObserver extends StatefulWidget {
  const LibraryObserver({required this.child, super.key});

  /// The child widget that will be wrapped by this observer.
  final Widget child;

  /// Retrieves the [LibraryObserverState] from the widget tree.
  static LibraryObserverState of(BuildContext context) =>
      context.read<LibraryObserverState>();

  @override
  State<LibraryObserver> createState() => LibraryObserverState();
}

/// The state for [LibraryObserver] that manages prompt listeners and notifications.
class LibraryObserverState extends State<LibraryObserver> {
  final List<ValueChanged<int>> _newPromptListeners = [];
  final List<ValueChanged<int>> _promptTitleOrDescriptionChangedListeners = [];

  /// Registers a listener to be notified when new prompts are added.
  ///
  /// The listener will receive the ID of the newly added prompt.
  void addNewPromptListener(ValueChanged<int> listener) {
    _newPromptListeners.add(listener);
  }

  /// Removes a previously registered prompt listener.
  void removeNewPromptListener(ValueChanged<int> listener) {
    _newPromptListeners.remove(listener);
  }

  void _notifyNewPromptListeners(int id) {
    for (final listener in _newPromptListeners) {
      listener(id);
    }
  }

  void _notifyPromptTitleOrDescriptionChangedListeners(int id) {
    for (final listener in _promptTitleOrDescriptionChangedListeners) {
      listener(id);
    }
  }

  void addPromptTitleOrDescriptionChangedListener(ValueChanged<int> listener) {
    _promptTitleOrDescriptionChangedListeners.add(listener);
  }

  void removePromptTitleOrDescriptionChangedListener(
      ValueChanged<int> listener) {
    _promptTitleOrDescriptionChangedListeners.remove(listener);
  }

  @override
  void dispose() {
    _newPromptListeners.clear();
    _promptTitleOrDescriptionChangedListeners.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<LibraryNotification>(
        onNotification: (notification) {
          switch (notification) {
            case NewPromptAddedNotification():
              _notifyNewPromptListeners(notification.id);
              return true;
            case PromptTitleOrDescriptionChangedNotification():
              _notifyPromptTitleOrDescriptionChangedListeners(notification.id);
              return true;
          }
        },
        child: Provider<LibraryObserverState>.value(
          value: this,
          child: widget.child,
        ),
      );
}

sealed class LibraryNotification extends Notification {
  const LibraryNotification({required this.id});

  final int id;
}

/// A notification that is dispatched when a new prompt is added to the library.
final class NewPromptAddedNotification extends LibraryNotification {
  const NewPromptAddedNotification({required super.id});
}

/// A notification that is dispatched when the title or description of a prompt is changed.
final class PromptTitleOrDescriptionChangedNotification
    extends LibraryNotification {
  const PromptTitleOrDescriptionChangedNotification({required super.id});
}
