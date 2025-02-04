import 'package:drift/drift.dart';

/// Table for organizing prompts and snippets into projects
class Projects extends Table {
  /// Primary key and unique identifier for the project
  IntColumn get id => integer().autoIncrement()();

  /// User-defined title of the project
  TextColumn get title => text().withDefault(const Constant(''))();

  /// User notes/description for the project
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// Emoji icon for the project (stored as unicode string)
  TextColumn get emoji => text().nullable()();

  /// Color for the project (stored as integer ARGB)
  IntColumn get color => integer().nullable()();

  /// Whether the project is starred
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();

  /// When the project was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the project was last modified
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
