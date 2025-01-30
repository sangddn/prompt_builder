import 'package:drift/drift.dart';

/// Table for storing code snippets and their metadata
class Snippets extends Table {
  /// Primary key and unique identifier for the snippet
  IntColumn get id => integer().autoIncrement()();

  /// User-defined title of the snippet
  /// This can be empty but defaults to an empty string
  TextColumn get title => text().withDefault(const Constant(''))();

  /// Main content of the snippet (e.g., code, text, etc.)
  /// This can be empty but defaults to an empty string
  TextColumn get content => text().withDefault(const Constant(''))();

  /// Optional AI-generated or user-provided summary of the content
  /// This can be null if no summary is available
  TextColumn get summary => text().nullable()();

  /// When the snippet was first created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the snippet was last modified
  /// Can be null if never modified after creation
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// When the snippet was last accessed/used
  /// Can be null if never used after creation
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
}
