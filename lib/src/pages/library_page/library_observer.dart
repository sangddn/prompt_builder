import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../main.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../services/services.dart';

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
  const LibraryObserver({
    required this.startFiles,
    required this.child,
    super.key,
  });

  /// The files imported at startup.
  final List<String> startFiles;

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
  final List<ValueChanged<int>> _promptTitleOrNotesChangedListeners = [];

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

  void _notifyPromptTitleOrNotesChangedListeners(int id) {
    for (final listener in _promptTitleOrNotesChangedListeners) {
      listener(id);
    }
  }

  void addPromptTitleOrNotesChangedListener(ValueChanged<int> listener) {
    _promptTitleOrNotesChangedListeners.add(listener);
  }

  void removePromptTitleOrNotesChangedListener(
    ValueChanged<int> listener,
  ) {
    _promptTitleOrNotesChangedListeners.remove(listener);
  }

  Future<void> _import(List<String> files) async {
    if (files.isEmpty) return;

    final toaster = context.toaster;
    final db = context.read<Database?>() ?? Database();
    final newIds = <int>[];

    for (final filePath in files) {
      try {
        final id = await PromptFileService.importPromptFromFile(
          db: db,
          filePath: filePath,
        );
        newIds.add(id);
      } catch (e) {
        toaster.show(
          ShadToast(
            title: Text('Error importing prompt at $filePath'),
            description: Text(e.toString(), maxLines: 5),
          ),
        );
      }
    }

    newIds.forEach(_notifyNewPromptListeners);
    toaster.show(
      ShadToast(
        title: Text('Imported ${newIds.length} prompts.'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _import(widget.startFiles);
    });
    kMethodChannel.setMethodCallHandler((call) async {
      if (call.method == 'handleOpenFiles') {
        final files = (call.arguments as List<dynamic>).cast<String>();
        _import(files);
      }
    });
  }

  @override
  void dispose() {
    _newPromptListeners.clear();
    _promptTitleOrNotesChangedListeners.clear();
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
            case PromptTitleOrNotesChangedNotification():
              _notifyPromptTitleOrNotesChangedListeners(notification.id);
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
final class PromptTitleOrNotesChangedNotification extends LibraryNotification {
  const PromptTitleOrNotesChangedNotification({required super.id});
}
