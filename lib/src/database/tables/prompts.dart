import 'package:drift/drift.dart';

import 'db_tables.dart';

/// Represents the database table for storing user-defined prompts.
///
/// Each prompt can be associated with a project and contains various
/// configurations like title, notes, tags, and folder paths for
/// organizing and managing prompts effectively.
class Prompts extends Table {
  /// Primary key for the prompt.
  IntColumn get id => integer().autoIncrement()();

  /// Optional reference to a project in the [Projects] table.
  ///
  /// When null, the prompt is not associated with any specific project.
  IntColumn get projectId => integer().nullable().references(Projects, #id)();

  /// User-defined title for the prompt.
  ///
  /// Defaults to an empty string if not specified.
  TextColumn get title => text().withDefault(const Constant(''))();

  /// Additional notes or description for the prompt.
  ///
  /// Defaults to an empty string if not specified.
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// The URL to the chat associated with the prompt, if any.
  TextColumn get chatUrl => text().nullable()();

  /// "|"-separated list of tags for categorizing the prompt.
  ///
  /// Defaults to an empty string if not specified.
  TextColumn get tags => text().withDefault(const Constant(''))();

  /// Optional directory path associated with the prompt.
  ///
  /// When specified, indicates a folder that should be opened or processed
  /// when using this prompt.
  TextColumn get folderPath => text().nullable()();

  /// Patterns for excluding files when processing the folder path.
  ///
  /// Defaults to an empty string if not specified. Multiple patterns
  /// should be separated by newlines.
  TextColumn get ignorePatterns => text().withDefault(const Constant(''))();

  /// Timestamp when the prompt was created.
  ///
  /// Automatically set to the current date and time when creating a new prompt.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the prompt was last modified.
  ///
  /// Null if the prompt has never been modified after creation.
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// Timestamp when the prompt was last opened or used.
  ///
  /// Null if the prompt has never been opened.
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
}
