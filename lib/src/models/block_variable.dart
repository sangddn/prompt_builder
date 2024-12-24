import 'package:drift/drift.dart';

class BlockVariables extends Table {
  // Unique ID for the variable
  IntColumn get id => integer().autoIncrement()();

  // Reference to the block
  IntColumn get blockId => integer().customConstraint('REFERENCES prompt_blocks(id)')();

  // The variable name inside {{ }} e.g. 'VARIABLE'
  TextColumn get varName => text()();

  // Default value from the text (if any)
  TextColumn get defaultValue => text().nullable()();

  // The user override if they typed something in that’s different
  TextColumn get userValue => text().nullable()();
}
