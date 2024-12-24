import 'package:drift/drift.dart';

class Prompts extends Table {
  // Unique ID of the prompt
  IntColumn get id => integer().autoIncrement()();

  // User-defined title of the prompt
  TextColumn get title => text().withDefault(const Constant(''))();

  // Optional folder path if user wants to open a directory
  TextColumn get folderPath => text().nullable()();

  // Patterns for ignoring files within the folder path
  TextColumn get ignorePatterns => text().withDefault(const Constant(''))();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
