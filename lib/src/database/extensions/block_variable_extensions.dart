import 'package:drift/drift.dart';
import '../database.dart';

extension BlockVariableExtension on Database {
  /// Insert or update block variables from text that contains {{VAR=default}}
  Future<void> syncBlockVariables(int blockId, String text) async {
    // naive parser: find all {{VAR=default}}
    final regex = RegExp(r'\{\{([^}=]+)=?([^}]*)\}\}');
    final matches = regex.allMatches(text);

    for (final match in matches) {
      final varName = match.group(1)?.trim();
      final defaultVal = match.group(2)?.trim();

      if (varName != null) {
        // Check if already in DB
        final existing = await (select(blockVariables)
              ..where(
                (t) => t.blockId.equals(blockId) & t.varName.equals(varName),
              ))
            .getSingleOrNull();

        if (existing == null) {
          // Insert
          await into(blockVariables).insert(
            BlockVariablesCompanion.insert(
              blockId: blockId,
              varName: varName,
              defaultValue: Value(defaultVal),
            ),
          );
        } else {
          // Update default value if needed
          await (update(blockVariables)..where((t) => t.id.equals(existing.id)))
              .write(
            BlockVariablesCompanion(
              defaultValue:
                  defaultVal != null ? Value(defaultVal) : const Value.absent(),
            ),
          );
        }
      }
    }
  }

  /// Update userValue for a given block variable
  Future<void> updateBlockVariableUserValue(int varId, String newValue) async {
    await (update(blockVariables)..where((t) => t.id.equals(varId))).write(
      BlockVariablesCompanion(userValue: Value(newValue)),
    );
  }

  /// Fetch all variables of a block
  Future<List<BlockVariable>> getVariablesByBlock(int blockId) {
    return (select(blockVariables)..where((tbl) => tbl.blockId.equals(blockId)))
        .get();
  }
}
