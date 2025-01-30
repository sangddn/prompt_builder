import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../../pages/library_page/library_observer.dart';
import '../../../services/services.dart';

Future<void> importPrompt(BuildContext context, Database db) async {
  final toaster = context.toaster;
  try {
    final pickedFiles = await FilePicker.platform.pickFiles(
      allowedExtensions: ['prompt'],
      allowMultiple: true,
      type: FileType.custom,
    );
    if (pickedFiles == null) return;
    for (final PlatformFile(path: path) in pickedFiles.files) {
      if (path == null) continue;
      final id = await PromptFileService.importPromptFromFile(
        db: db,
        filePath: path,
      );
      if (!context.mounted) return;
      NewPromptAddedNotification(id: id).dispatch(context);
    }
  } catch (e) {
    debugPrint('Failed to import prompt files: $e');
    toaster.show(
      ShadToast.destructive(
        title: const Text('Failed to import prompt files.'),
        description: Text(e.toString()),
      ),
    );
  }
}

Future<void> exportPrompt(
  BuildContext context,
  Database db,
  int promptId,
) async {
  final toaster = context.toaster;
  try {
    // Export
    final filePath = await PromptFileService.exportPromptToFile(
      db: db,
      promptId: promptId,
    );

    // Aborted by user
    if (filePath == null) return;

    toaster.show(
      ShadToast(
        title: const Text('Prompt exported'),
        description: Text(filePath),
        action: ShadButton.ghost(
          onPressed: () => revealInFinder(filePath),
          child: const Text('Open'),
        ),
      ),
    );
  } catch (e) {
    debugPrint('Failed to export prompt files: $e');
    toaster.show(
      ShadToast.destructive(
        title: const Text('Failed to export prompt files.'),
        description: Text(e.toString()),
      ),
    );
  }
}
