import 'package:drift/drift.dart';

class Snippets extends Table {
  // Unique ID of the snippet
  IntColumn get id => integer().autoIncrement()();

  // User-defined title of the snippet
  TextColumn get title => text().withDefault(const Constant(''))();

  // Content of the snippet
  TextColumn get content => text().withDefault(const Constant(''))();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
}
