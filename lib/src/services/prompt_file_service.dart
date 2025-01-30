import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../database/database.dart';
import '../database/prompt_export/prompt_export.dart';

/// Service class responsible for importing and exporting prompts to/from files.
///
/// Provides functionality to serialize prompts to JSON files and deserialize them
/// back into the database.
abstract final class PromptFileService {
  /// Exports a prompt and its associated blocks to a JSON file.
  ///
  /// Parameters:
  /// - [db]: The database instance to fetch the prompt data from
  /// - [promptId]: The ID of the prompt to export
  /// - [directoryPath]: The destination directory where the prompt will be saved
  ///
  /// The exported file will contain a JSON representation of the prompt and all
  /// its associated blocks.
  ///
  /// Returns the full path to the exported file.
  static Future<String?> exportPromptToFile({
    required Database db,
    required int promptId,
  }) async {
    const lastUsedDirKey = 'exportPromptLastUsedDirectory';
    final lastUsedDirectory = db.stringRef.get(lastUsedDirKey);

    // 1) Get the prompt data.
    final prompt = await db.getPrompt(promptId);
    final blocks = await db.getBlocksByPrompt(promptId);

    // 2) Convert to export model.
    final exportModel = PromptExport.fromPromptAndBlocks(prompt, blocks);

    // 3) Convert to JSON string.
    final jsonString = await compute(jsonEncode, exportModel.toJson());

    // 4) Build the file path.
    var safeTitle = prompt.title
        .replaceAll(
          RegExp(r'[\\/:*?"<>|]+'),
          '_',
        ) // basic invalid-file-char cleanup
        .replaceAll(' ', '_');
    safeTitle = safeTitle.isEmpty ? 'Untitled' : safeTitle;
    final filePath = await FilePicker.platform.saveFile(
      dialogTitle:
          'Exporting ${prompt.title.isEmpty ? 'Prompt' : prompt.title}',
      fileName: '$safeTitle.prompt',
      type: FileType.custom,
      allowedExtensions: ['prompt'],
      lockParentWindow: true,
      initialDirectory: lastUsedDirectory,
    );
    if (filePath == null) return null;

    await db.stringRef.put(lastUsedDirKey, p.dirname(filePath));

    // 5) Write it to disk.
    final file = File(filePath);
    await file.writeAsString(jsonString);

    return filePath;
  }

  /// Imports a prompt from a JSON file into the database.
  ///
  /// Parameters:
  /// - [db]: The database instance to import the prompt into
  /// - [filePath]: The path to the JSON file containing the prompt data
  ///
  /// Returns the ID of the newly created prompt in the database.
  ///
  /// The imported file should be in the correct JSON format as exported by
  /// [exportPromptToFile]. The method will create a new prompt entry and all
  /// its associated blocks in the database.
  static Future<int> importPromptFromFile({
    required Database db,
    required String filePath,
  }) async {
    if (!p.extension(filePath).endsWith('.prompt')) {
      debugPrint('Imported file must have a .prompt extension!');
      return -1;
    }

    // 1) Read JSON from the .prompt file
    final file = File(filePath);
    final jsonString = await file.readAsString();
    final jsonMap =
        (await compute(jsonDecode, jsonString)) as Map<String, dynamic>;

    // 2) Convert to your export model
    final exportModel = PromptExport.fromJson(jsonMap);

    // 3) Create a new prompt in the DB
    final newPromptId = await db.createPrompt(
      title: exportModel.title,
      notes: exportModel.notes,
      tags: exportModel.tagList,
    );

    // 4) Insert the blocks
    for (final blockExport in exportModel.blocks) {
      await db.createBlock(
        promptId: newPromptId,
        blockType: BlockType.values.firstWhere(
          (b) => b.name == blockExport.blockType,
          orElse: () => BlockType.unsupported,
        ),
        displayName: blockExport.displayName,
        sortOrder: blockExport.sortOrder,
        textContent: blockExport.textContent,
        filePath: blockExport.filePath,
        url: blockExport.url,
        transcript: blockExport.transcript,
        caption: blockExport.caption,
        summary: blockExport.summary,
      );
    }

    return newPromptId;
  }
}
