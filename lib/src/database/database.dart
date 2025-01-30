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

@DriftDatabase(tables: [Prompts, PromptBlocks, Snippets])
final class Database extends _$Database {
  factory Database() => instance;
  Database.custom(String name) : super(_openConnection(name));

  static final instance = Database.custom('prompt_builder');

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(snippets, snippets.summary as GeneratedColumn);
          }
        },
      );

  static QueryExecutor _openConnection(String name) {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(
      name: name,
      native: DriftNativeOptions(
        databasePath: () async => '${await getApplicationPath()}/$name.sqlite',
      ),
    );
  }

  bool isInitialized = false;

  late final Box<bool> boolRef;
  late final Box<String> stringRef;
  late final Box<double> doubleRef;
  late final Box<DateTime> dateTimeRef;

  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    debugPrint('Initializing AppDatabase...');

    Hive.init(await getApplicationPath());
    boolRef = await Hive.openBox<bool>('boolMap');
    stringRef = await Hive.openBox<String>('stringMap');
    doubleRef = await Hive.openBox<double>('doubleMap');
    dateTimeRef = await Hive.openBox<DateTime>('dateTimeMap');

    isInitialized = true;

    debugPrint('Local database initialized. 🚀');

    return;
  }

  void closeBoxes() {
    boolRef.close();
    stringRef.close();
    doubleRef.close();
    dateTimeRef.close();
  }
}

@visibleForTesting
final class MockDatabase extends Database {
  MockDatabase() : super.custom('mock_db');

  @override
  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    debugPrint('Initializing MockDatabase...');

    boolRef = await Hive.openBox<bool>('mockBoolMap', path: '.');
    stringRef = await Hive.openBox<String>('mockStringMap', path: '.');
    doubleRef = await Hive.openBox<double>('mockDoubleMap', path: '.');
    dateTimeRef = await Hive.openBox<DateTime>('mockDateTimeMap', path: '.');

    isInitialized = true;

    debugPrint('Mock database initialized. 🚀');

    return;
  }
}

Future<String> getApplicationPath() async =>
    '${(await getApplicationDocumentsDirectory()).path}/${kDebugMode ? 'Prompt Builder (Debug)' : 'Prompt Builder'}';
