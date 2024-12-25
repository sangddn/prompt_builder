import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/db_tables.dart';

export 'extensions/db_extensions.dart';
export 'tables/db_tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Prompts, PromptBlocks, BlockVariables, Snippets])
final class Database extends _$Database {
  factory Database() => instance;
  Database._() : super(_openConnection());

  static final instance = Database._();

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(name: 'prompt_builder_db');
  }

  bool isInitialized = false;

  late final Box<bool> boolRef;
  late final Box<String> stringRef;
  late final Box<int> intRef;
  late final Box<double> doubleRef;
  late final Box<DateTime> dateTimeRef;

  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    debugPrint('Initializing AppDatabase...');

    final dir = await getApplicationDocumentsDirectory();

    Hive.init(dir.path);
    boolRef = await Hive.openBox<bool>('boolMap');
    stringRef = await Hive.openBox<String>('stringMap');
    intRef = await Hive.openBox<int>('intMap');
    doubleRef = await Hive.openBox<double>('doubleMap');
    dateTimeRef = await Hive.openBox<DateTime>('dateTimeMap');

    isInitialized = true;

    debugPrint('Local database initialized. 🚀');

    return;
  }

  void closeBoxes() {
    boolRef.close();
    stringRef.close();
    intRef.close();
    doubleRef.close();
    dateTimeRef.close();
  }
}
