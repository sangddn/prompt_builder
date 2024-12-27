// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PromptsTable extends Prompts with TableInfo<$PromptsTable, Prompt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _folderPathMeta =
      const VerificationMeta('folderPath');
  @override
  late final GeneratedColumn<String> folderPath = GeneratedColumn<String>(
      'folder_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ignorePatternsMeta =
      const VerificationMeta('ignorePatterns');
  @override
  late final GeneratedColumn<String> ignorePatterns = GeneratedColumn<String>(
      'ignore_patterns', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastOpenedAtMeta =
      const VerificationMeta('lastOpenedAt');
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
      'last_opened_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        notes,
        tags,
        folderPath,
        ignorePatterns,
        createdAt,
        updatedAt,
        lastOpenedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prompts';
  @override
  VerificationContext validateIntegrity(Insertable<Prompt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('folder_path')) {
      context.handle(
          _folderPathMeta,
          folderPath.isAcceptableOrUnknown(
              data['folder_path']!, _folderPathMeta));
    }
    if (data.containsKey('ignore_patterns')) {
      context.handle(
          _ignorePatternsMeta,
          ignorePatterns.isAcceptableOrUnknown(
              data['ignore_patterns']!, _ignorePatternsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
          _lastOpenedAtMeta,
          lastOpenedAt.isAcceptableOrUnknown(
              data['last_opened_at']!, _lastOpenedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prompt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prompt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      folderPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_path']),
      ignorePatterns: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ignore_patterns'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      lastOpenedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_opened_at']),
    );
  }

  @override
  $PromptsTable createAlias(String alias) {
    return $PromptsTable(attachedDatabase, alias);
  }
}

class Prompt extends DataClass implements Insertable<Prompt> {
  final int id;
  final String title;
  final String notes;
  final String tags;
  final String? folderPath;
  final String ignorePatterns;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastOpenedAt;
  const Prompt(
      {required this.id,
      required this.title,
      required this.notes,
      required this.tags,
      this.folderPath,
      required this.ignorePatterns,
      required this.createdAt,
      this.updatedAt,
      this.lastOpenedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['notes'] = Variable<String>(notes);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || folderPath != null) {
      map['folder_path'] = Variable<String>(folderPath);
    }
    map['ignore_patterns'] = Variable<String>(ignorePatterns);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    return map;
  }

  PromptsCompanion toCompanion(bool nullToAbsent) {
    return PromptsCompanion(
      id: Value(id),
      title: Value(title),
      notes: Value(notes),
      tags: Value(tags),
      folderPath: folderPath == null && nullToAbsent
          ? const Value.absent()
          : Value(folderPath),
      ignorePatterns: Value(ignorePatterns),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
    );
  }

  factory Prompt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prompt(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String>(json['notes']),
      tags: serializer.fromJson<String>(json['tags']),
      folderPath: serializer.fromJson<String?>(json['folderPath']),
      ignorePatterns: serializer.fromJson<String>(json['ignorePatterns']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String>(notes),
      'tags': serializer.toJson<String>(tags),
      'folderPath': serializer.toJson<String?>(folderPath),
      'ignorePatterns': serializer.toJson<String>(ignorePatterns),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
    };
  }

  Prompt copyWith(
          {int? id,
          String? title,
          String? notes,
          String? tags,
          Value<String?> folderPath = const Value.absent(),
          String? ignorePatterns,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> lastOpenedAt = const Value.absent()}) =>
      Prompt(
        id: id ?? this.id,
        title: title ?? this.title,
        notes: notes ?? this.notes,
        tags: tags ?? this.tags,
        folderPath: folderPath.present ? folderPath.value : this.folderPath,
        ignorePatterns: ignorePatterns ?? this.ignorePatterns,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        lastOpenedAt:
            lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
      );
  Prompt copyWithCompanion(PromptsCompanion data) {
    return Prompt(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      folderPath:
          data.folderPath.present ? data.folderPath.value : this.folderPath,
      ignorePatterns: data.ignorePatterns.present
          ? data.ignorePatterns.value
          : this.ignorePatterns,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prompt(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('folderPath: $folderPath, ')
          ..write('ignorePatterns: $ignorePatterns, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, notes, tags, folderPath,
      ignorePatterns, createdAt, updatedAt, lastOpenedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prompt &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.folderPath == this.folderPath &&
          other.ignorePatterns == this.ignorePatterns &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class PromptsCompanion extends UpdateCompanion<Prompt> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> notes;
  final Value<String> tags;
  final Value<String?> folderPath;
  final Value<String> ignorePatterns;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> lastOpenedAt;
  const PromptsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.ignorePatterns = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  PromptsCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.ignorePatterns = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  static Insertable<Prompt> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<String>? folderPath,
    Expression<String>? ignorePatterns,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastOpenedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (folderPath != null) 'folder_path': folderPath,
      if (ignorePatterns != null) 'ignore_patterns': ignorePatterns,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
    });
  }

  PromptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? notes,
      Value<String>? tags,
      Value<String?>? folderPath,
      Value<String>? ignorePatterns,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? lastOpenedAt}) {
    return PromptsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      folderPath: folderPath ?? this.folderPath,
      ignorePatterns: ignorePatterns ?? this.ignorePatterns,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (folderPath.present) {
      map['folder_path'] = Variable<String>(folderPath.value);
    }
    if (ignorePatterns.present) {
      map['ignore_patterns'] = Variable<String>(ignorePatterns.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromptsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('folderPath: $folderPath, ')
          ..write('ignorePatterns: $ignorePatterns, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }
}

class $PromptBlocksTable extends PromptBlocks
    with TableInfo<$PromptBlocksTable, PromptBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromptBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _promptIdMeta =
      const VerificationMeta('promptId');
  @override
  late final GeneratedColumn<int> promptId = GeneratedColumn<int>(
      'prompt_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES prompts (id)'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<double> sortOrder = GeneratedColumn<double>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _blockTypeMeta =
      const VerificationMeta('blockType');
  @override
  late final GeneratedColumn<String> blockType = GeneratedColumn<String>(
      'block_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _textContentTokenCountMeta =
      const VerificationMeta('textContentTokenCount');
  @override
  late final GeneratedColumn<int> textContentTokenCount = GeneratedColumn<int>(
      'text_content_token_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _summaryTokenCountMeta =
      const VerificationMeta('summaryTokenCount');
  @override
  late final GeneratedColumn<int> summaryTokenCount = GeneratedColumn<int>(
      'summary_token_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _transcriptTokenCountMeta =
      const VerificationMeta('transcriptTokenCount');
  @override
  late final GeneratedColumn<int> transcriptTokenCount = GeneratedColumn<int>(
      'transcript_token_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _captionTokenCountMeta =
      const VerificationMeta('captionTokenCount');
  @override
  late final GeneratedColumn<int> captionTokenCount = GeneratedColumn<int>(
      'caption_token_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'text_content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transcriptMeta =
      const VerificationMeta('transcript');
  @override
  late final GeneratedColumn<String> transcript = GeneratedColumn<String>(
      'transcript', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _captionMeta =
      const VerificationMeta('caption');
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
      'caption', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        promptId,
        sortOrder,
        blockType,
        displayName,
        textContentTokenCount,
        summaryTokenCount,
        transcriptTokenCount,
        captionTokenCount,
        textContent,
        filePath,
        mimeType,
        fileSize,
        url,
        transcript,
        caption,
        summary,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prompt_blocks';
  @override
  VerificationContext validateIntegrity(Insertable<PromptBlock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prompt_id')) {
      context.handle(_promptIdMeta,
          promptId.isAcceptableOrUnknown(data['prompt_id']!, _promptIdMeta));
    } else if (isInserting) {
      context.missing(_promptIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('block_type')) {
      context.handle(_blockTypeMeta,
          blockType.isAcceptableOrUnknown(data['block_type']!, _blockTypeMeta));
    } else if (isInserting) {
      context.missing(_blockTypeMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('text_content_token_count')) {
      context.handle(
          _textContentTokenCountMeta,
          textContentTokenCount.isAcceptableOrUnknown(
              data['text_content_token_count']!, _textContentTokenCountMeta));
    }
    if (data.containsKey('summary_token_count')) {
      context.handle(
          _summaryTokenCountMeta,
          summaryTokenCount.isAcceptableOrUnknown(
              data['summary_token_count']!, _summaryTokenCountMeta));
    }
    if (data.containsKey('transcript_token_count')) {
      context.handle(
          _transcriptTokenCountMeta,
          transcriptTokenCount.isAcceptableOrUnknown(
              data['transcript_token_count']!, _transcriptTokenCountMeta));
    }
    if (data.containsKey('caption_token_count')) {
      context.handle(
          _captionTokenCountMeta,
          captionTokenCount.isAcceptableOrUnknown(
              data['caption_token_count']!, _captionTokenCountMeta));
    }
    if (data.containsKey('text_content')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['text_content']!, _textContentMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('transcript')) {
      context.handle(
          _transcriptMeta,
          transcript.isAcceptableOrUnknown(
              data['transcript']!, _transcriptMeta));
    }
    if (data.containsKey('caption')) {
      context.handle(_captionMeta,
          caption.isAcceptableOrUnknown(data['caption']!, _captionMeta));
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromptBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromptBlock(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      promptId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prompt_id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sort_order'])!,
      blockType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}block_type'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      textContentTokenCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}text_content_token_count']),
      summaryTokenCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}summary_token_count']),
      transcriptTokenCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}transcript_token_count']),
      captionTokenCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}caption_token_count']),
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_content']),
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url']),
      transcript: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transcript']),
      caption: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}caption']),
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $PromptBlocksTable createAlias(String alias) {
    return $PromptBlocksTable(attachedDatabase, alias);
  }
}

class PromptBlock extends DataClass implements Insertable<PromptBlock> {
  /// Unique identifier for each block
  final int id;

  /// Reference to the parent prompt this block belongs to
  final int promptId;

  /// Position of this block within the prompt's sequence of blocks
  /// Defaults to 0 if not specified
  final double sortOrder;

  /// The type of content in this block, stored as a string representation
  /// of the [BlockType] enum
  final String blockType;

  /// User-facing name/title for this block
  final String displayName;

  /// Number of tokens in this block's content, used for API limits
  final int? textContentTokenCount;

  /// Number of tokens in this block's summary, used for API limits
  final int? summaryTokenCount;

  /// Number of tokens in this block's transcript, used for API limits
  final int? transcriptTokenCount;

  /// Number of tokens in this block's caption, used for API limits
  final int? captionTokenCount;

  /// Main text content for text-based blocks
  /// Nullable since not all block types contain text
  final String? textContent;

  /// Local filesystem path or app directory path for file-backed content
  final String? filePath;

  /// MIME type of the content (e.g. 'application/pdf', 'audio/wav')
  /// Used for proper handling of different file formats
  final String? mimeType;

  /// Size of the file in bytes, if applicable
  final int? fileSize;

  /// URL for web-based content (YouTube videos, web pages, remote media)
  final String? url;

  /// Transcribed text content for audio/video content
  final String? transcript;

  /// Caption or alt text for image content
  final String? caption;

  /// Condensed version of large text content or transcripts
  final String? summary;

  /// Timestamp when this block was created
  final DateTime createdAt;

  /// Timestamp when this block was last modified
  final DateTime? updatedAt;
  const PromptBlock(
      {required this.id,
      required this.promptId,
      required this.sortOrder,
      required this.blockType,
      required this.displayName,
      this.textContentTokenCount,
      this.summaryTokenCount,
      this.transcriptTokenCount,
      this.captionTokenCount,
      this.textContent,
      this.filePath,
      this.mimeType,
      this.fileSize,
      this.url,
      this.transcript,
      this.caption,
      this.summary,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prompt_id'] = Variable<int>(promptId);
    map['sort_order'] = Variable<double>(sortOrder);
    map['block_type'] = Variable<String>(blockType);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || textContentTokenCount != null) {
      map['text_content_token_count'] = Variable<int>(textContentTokenCount);
    }
    if (!nullToAbsent || summaryTokenCount != null) {
      map['summary_token_count'] = Variable<int>(summaryTokenCount);
    }
    if (!nullToAbsent || transcriptTokenCount != null) {
      map['transcript_token_count'] = Variable<int>(transcriptTokenCount);
    }
    if (!nullToAbsent || captionTokenCount != null) {
      map['caption_token_count'] = Variable<int>(captionTokenCount);
    }
    if (!nullToAbsent || textContent != null) {
      map['text_content'] = Variable<String>(textContent);
    }
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || transcript != null) {
      map['transcript'] = Variable<String>(transcript);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PromptBlocksCompanion toCompanion(bool nullToAbsent) {
    return PromptBlocksCompanion(
      id: Value(id),
      promptId: Value(promptId),
      sortOrder: Value(sortOrder),
      blockType: Value(blockType),
      displayName: Value(displayName),
      textContentTokenCount: textContentTokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(textContentTokenCount),
      summaryTokenCount: summaryTokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryTokenCount),
      transcriptTokenCount: transcriptTokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(transcriptTokenCount),
      captionTokenCount: captionTokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(captionTokenCount),
      textContent: textContent == null && nullToAbsent
          ? const Value.absent()
          : Value(textContent),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      transcript: transcript == null && nullToAbsent
          ? const Value.absent()
          : Value(transcript),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PromptBlock.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromptBlock(
      id: serializer.fromJson<int>(json['id']),
      promptId: serializer.fromJson<int>(json['promptId']),
      sortOrder: serializer.fromJson<double>(json['sortOrder']),
      blockType: serializer.fromJson<String>(json['blockType']),
      displayName: serializer.fromJson<String>(json['displayName']),
      textContentTokenCount:
          serializer.fromJson<int?>(json['textContentTokenCount']),
      summaryTokenCount: serializer.fromJson<int?>(json['summaryTokenCount']),
      transcriptTokenCount:
          serializer.fromJson<int?>(json['transcriptTokenCount']),
      captionTokenCount: serializer.fromJson<int?>(json['captionTokenCount']),
      textContent: serializer.fromJson<String?>(json['textContent']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      url: serializer.fromJson<String?>(json['url']),
      transcript: serializer.fromJson<String?>(json['transcript']),
      caption: serializer.fromJson<String?>(json['caption']),
      summary: serializer.fromJson<String?>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'promptId': serializer.toJson<int>(promptId),
      'sortOrder': serializer.toJson<double>(sortOrder),
      'blockType': serializer.toJson<String>(blockType),
      'displayName': serializer.toJson<String>(displayName),
      'textContentTokenCount': serializer.toJson<int?>(textContentTokenCount),
      'summaryTokenCount': serializer.toJson<int?>(summaryTokenCount),
      'transcriptTokenCount': serializer.toJson<int?>(transcriptTokenCount),
      'captionTokenCount': serializer.toJson<int?>(captionTokenCount),
      'textContent': serializer.toJson<String?>(textContent),
      'filePath': serializer.toJson<String?>(filePath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'fileSize': serializer.toJson<int?>(fileSize),
      'url': serializer.toJson<String?>(url),
      'transcript': serializer.toJson<String?>(transcript),
      'caption': serializer.toJson<String?>(caption),
      'summary': serializer.toJson<String?>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PromptBlock copyWith(
          {int? id,
          int? promptId,
          double? sortOrder,
          String? blockType,
          String? displayName,
          Value<int?> textContentTokenCount = const Value.absent(),
          Value<int?> summaryTokenCount = const Value.absent(),
          Value<int?> transcriptTokenCount = const Value.absent(),
          Value<int?> captionTokenCount = const Value.absent(),
          Value<String?> textContent = const Value.absent(),
          Value<String?> filePath = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          Value<int?> fileSize = const Value.absent(),
          Value<String?> url = const Value.absent(),
          Value<String?> transcript = const Value.absent(),
          Value<String?> caption = const Value.absent(),
          Value<String?> summary = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      PromptBlock(
        id: id ?? this.id,
        promptId: promptId ?? this.promptId,
        sortOrder: sortOrder ?? this.sortOrder,
        blockType: blockType ?? this.blockType,
        displayName: displayName ?? this.displayName,
        textContentTokenCount: textContentTokenCount.present
            ? textContentTokenCount.value
            : this.textContentTokenCount,
        summaryTokenCount: summaryTokenCount.present
            ? summaryTokenCount.value
            : this.summaryTokenCount,
        transcriptTokenCount: transcriptTokenCount.present
            ? transcriptTokenCount.value
            : this.transcriptTokenCount,
        captionTokenCount: captionTokenCount.present
            ? captionTokenCount.value
            : this.captionTokenCount,
        textContent: textContent.present ? textContent.value : this.textContent,
        filePath: filePath.present ? filePath.value : this.filePath,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        fileSize: fileSize.present ? fileSize.value : this.fileSize,
        url: url.present ? url.value : this.url,
        transcript: transcript.present ? transcript.value : this.transcript,
        caption: caption.present ? caption.value : this.caption,
        summary: summary.present ? summary.value : this.summary,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  PromptBlock copyWithCompanion(PromptBlocksCompanion data) {
    return PromptBlock(
      id: data.id.present ? data.id.value : this.id,
      promptId: data.promptId.present ? data.promptId.value : this.promptId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      blockType: data.blockType.present ? data.blockType.value : this.blockType,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      textContentTokenCount: data.textContentTokenCount.present
          ? data.textContentTokenCount.value
          : this.textContentTokenCount,
      summaryTokenCount: data.summaryTokenCount.present
          ? data.summaryTokenCount.value
          : this.summaryTokenCount,
      transcriptTokenCount: data.transcriptTokenCount.present
          ? data.transcriptTokenCount.value
          : this.transcriptTokenCount,
      captionTokenCount: data.captionTokenCount.present
          ? data.captionTokenCount.value
          : this.captionTokenCount,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      url: data.url.present ? data.url.value : this.url,
      transcript:
          data.transcript.present ? data.transcript.value : this.transcript,
      caption: data.caption.present ? data.caption.value : this.caption,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromptBlock(')
          ..write('id: $id, ')
          ..write('promptId: $promptId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('blockType: $blockType, ')
          ..write('displayName: $displayName, ')
          ..write('textContentTokenCount: $textContentTokenCount, ')
          ..write('summaryTokenCount: $summaryTokenCount, ')
          ..write('transcriptTokenCount: $transcriptTokenCount, ')
          ..write('captionTokenCount: $captionTokenCount, ')
          ..write('textContent: $textContent, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('url: $url, ')
          ..write('transcript: $transcript, ')
          ..write('caption: $caption, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      promptId,
      sortOrder,
      blockType,
      displayName,
      textContentTokenCount,
      summaryTokenCount,
      transcriptTokenCount,
      captionTokenCount,
      textContent,
      filePath,
      mimeType,
      fileSize,
      url,
      transcript,
      caption,
      summary,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromptBlock &&
          other.id == this.id &&
          other.promptId == this.promptId &&
          other.sortOrder == this.sortOrder &&
          other.blockType == this.blockType &&
          other.displayName == this.displayName &&
          other.textContentTokenCount == this.textContentTokenCount &&
          other.summaryTokenCount == this.summaryTokenCount &&
          other.transcriptTokenCount == this.transcriptTokenCount &&
          other.captionTokenCount == this.captionTokenCount &&
          other.textContent == this.textContent &&
          other.filePath == this.filePath &&
          other.mimeType == this.mimeType &&
          other.fileSize == this.fileSize &&
          other.url == this.url &&
          other.transcript == this.transcript &&
          other.caption == this.caption &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PromptBlocksCompanion extends UpdateCompanion<PromptBlock> {
  final Value<int> id;
  final Value<int> promptId;
  final Value<double> sortOrder;
  final Value<String> blockType;
  final Value<String> displayName;
  final Value<int?> textContentTokenCount;
  final Value<int?> summaryTokenCount;
  final Value<int?> transcriptTokenCount;
  final Value<int?> captionTokenCount;
  final Value<String?> textContent;
  final Value<String?> filePath;
  final Value<String?> mimeType;
  final Value<int?> fileSize;
  final Value<String?> url;
  final Value<String?> transcript;
  final Value<String?> caption;
  final Value<String?> summary;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const PromptBlocksCompanion({
    this.id = const Value.absent(),
    this.promptId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.blockType = const Value.absent(),
    this.displayName = const Value.absent(),
    this.textContentTokenCount = const Value.absent(),
    this.summaryTokenCount = const Value.absent(),
    this.transcriptTokenCount = const Value.absent(),
    this.captionTokenCount = const Value.absent(),
    this.textContent = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.url = const Value.absent(),
    this.transcript = const Value.absent(),
    this.caption = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PromptBlocksCompanion.insert({
    this.id = const Value.absent(),
    required int promptId,
    this.sortOrder = const Value.absent(),
    required String blockType,
    this.displayName = const Value.absent(),
    this.textContentTokenCount = const Value.absent(),
    this.summaryTokenCount = const Value.absent(),
    this.transcriptTokenCount = const Value.absent(),
    this.captionTokenCount = const Value.absent(),
    this.textContent = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.url = const Value.absent(),
    this.transcript = const Value.absent(),
    this.caption = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : promptId = Value(promptId),
        blockType = Value(blockType);
  static Insertable<PromptBlock> custom({
    Expression<int>? id,
    Expression<int>? promptId,
    Expression<double>? sortOrder,
    Expression<String>? blockType,
    Expression<String>? displayName,
    Expression<int>? textContentTokenCount,
    Expression<int>? summaryTokenCount,
    Expression<int>? transcriptTokenCount,
    Expression<int>? captionTokenCount,
    Expression<String>? textContent,
    Expression<String>? filePath,
    Expression<String>? mimeType,
    Expression<int>? fileSize,
    Expression<String>? url,
    Expression<String>? transcript,
    Expression<String>? caption,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (promptId != null) 'prompt_id': promptId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (blockType != null) 'block_type': blockType,
      if (displayName != null) 'display_name': displayName,
      if (textContentTokenCount != null)
        'text_content_token_count': textContentTokenCount,
      if (summaryTokenCount != null) 'summary_token_count': summaryTokenCount,
      if (transcriptTokenCount != null)
        'transcript_token_count': transcriptTokenCount,
      if (captionTokenCount != null) 'caption_token_count': captionTokenCount,
      if (textContent != null) 'text_content': textContent,
      if (filePath != null) 'file_path': filePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (fileSize != null) 'file_size': fileSize,
      if (url != null) 'url': url,
      if (transcript != null) 'transcript': transcript,
      if (caption != null) 'caption': caption,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PromptBlocksCompanion copyWith(
      {Value<int>? id,
      Value<int>? promptId,
      Value<double>? sortOrder,
      Value<String>? blockType,
      Value<String>? displayName,
      Value<int?>? textContentTokenCount,
      Value<int?>? summaryTokenCount,
      Value<int?>? transcriptTokenCount,
      Value<int?>? captionTokenCount,
      Value<String?>? textContent,
      Value<String?>? filePath,
      Value<String?>? mimeType,
      Value<int?>? fileSize,
      Value<String?>? url,
      Value<String?>? transcript,
      Value<String?>? caption,
      Value<String?>? summary,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return PromptBlocksCompanion(
      id: id ?? this.id,
      promptId: promptId ?? this.promptId,
      sortOrder: sortOrder ?? this.sortOrder,
      blockType: blockType ?? this.blockType,
      displayName: displayName ?? this.displayName,
      textContentTokenCount:
          textContentTokenCount ?? this.textContentTokenCount,
      summaryTokenCount: summaryTokenCount ?? this.summaryTokenCount,
      transcriptTokenCount: transcriptTokenCount ?? this.transcriptTokenCount,
      captionTokenCount: captionTokenCount ?? this.captionTokenCount,
      textContent: textContent ?? this.textContent,
      filePath: filePath ?? this.filePath,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      url: url ?? this.url,
      transcript: transcript ?? this.transcript,
      caption: caption ?? this.caption,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (promptId.present) {
      map['prompt_id'] = Variable<int>(promptId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<double>(sortOrder.value);
    }
    if (blockType.present) {
      map['block_type'] = Variable<String>(blockType.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (textContentTokenCount.present) {
      map['text_content_token_count'] =
          Variable<int>(textContentTokenCount.value);
    }
    if (summaryTokenCount.present) {
      map['summary_token_count'] = Variable<int>(summaryTokenCount.value);
    }
    if (transcriptTokenCount.present) {
      map['transcript_token_count'] = Variable<int>(transcriptTokenCount.value);
    }
    if (captionTokenCount.present) {
      map['caption_token_count'] = Variable<int>(captionTokenCount.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (transcript.present) {
      map['transcript'] = Variable<String>(transcript.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromptBlocksCompanion(')
          ..write('id: $id, ')
          ..write('promptId: $promptId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('blockType: $blockType, ')
          ..write('displayName: $displayName, ')
          ..write('textContentTokenCount: $textContentTokenCount, ')
          ..write('summaryTokenCount: $summaryTokenCount, ')
          ..write('transcriptTokenCount: $transcriptTokenCount, ')
          ..write('captionTokenCount: $captionTokenCount, ')
          ..write('textContent: $textContent, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('url: $url, ')
          ..write('transcript: $transcript, ')
          ..write('caption: $caption, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BlockVariablesTable extends BlockVariables
    with TableInfo<$BlockVariablesTable, BlockVariable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockVariablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _blockIdMeta =
      const VerificationMeta('blockId');
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
      'block_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES prompt_blocks (id)'));
  static const VerificationMeta _varNameMeta =
      const VerificationMeta('varName');
  @override
  late final GeneratedColumn<String> varName = GeneratedColumn<String>(
      'var_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultValueMeta =
      const VerificationMeta('defaultValue');
  @override
  late final GeneratedColumn<String> defaultValue = GeneratedColumn<String>(
      'default_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userValueMeta =
      const VerificationMeta('userValue');
  @override
  late final GeneratedColumn<String> userValue = GeneratedColumn<String>(
      'user_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, blockId, varName, defaultValue, userValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'block_variables';
  @override
  VerificationContext validateIntegrity(Insertable<BlockVariable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(_blockIdMeta,
          blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta));
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('var_name')) {
      context.handle(_varNameMeta,
          varName.isAcceptableOrUnknown(data['var_name']!, _varNameMeta));
    } else if (isInserting) {
      context.missing(_varNameMeta);
    }
    if (data.containsKey('default_value')) {
      context.handle(
          _defaultValueMeta,
          defaultValue.isAcceptableOrUnknown(
              data['default_value']!, _defaultValueMeta));
    }
    if (data.containsKey('user_value')) {
      context.handle(_userValueMeta,
          userValue.isAcceptableOrUnknown(data['user_value']!, _userValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockVariable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockVariable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      blockId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}block_id'])!,
      varName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}var_name'])!,
      defaultValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_value']),
      userValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_value']),
    );
  }

  @override
  $BlockVariablesTable createAlias(String alias) {
    return $BlockVariablesTable(attachedDatabase, alias);
  }
}

class BlockVariable extends DataClass implements Insertable<BlockVariable> {
  final int id;
  final int blockId;
  final String varName;
  final String? defaultValue;
  final String? userValue;
  const BlockVariable(
      {required this.id,
      required this.blockId,
      required this.varName,
      this.defaultValue,
      this.userValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['block_id'] = Variable<int>(blockId);
    map['var_name'] = Variable<String>(varName);
    if (!nullToAbsent || defaultValue != null) {
      map['default_value'] = Variable<String>(defaultValue);
    }
    if (!nullToAbsent || userValue != null) {
      map['user_value'] = Variable<String>(userValue);
    }
    return map;
  }

  BlockVariablesCompanion toCompanion(bool nullToAbsent) {
    return BlockVariablesCompanion(
      id: Value(id),
      blockId: Value(blockId),
      varName: Value(varName),
      defaultValue: defaultValue == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultValue),
      userValue: userValue == null && nullToAbsent
          ? const Value.absent()
          : Value(userValue),
    );
  }

  factory BlockVariable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockVariable(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int>(json['blockId']),
      varName: serializer.fromJson<String>(json['varName']),
      defaultValue: serializer.fromJson<String?>(json['defaultValue']),
      userValue: serializer.fromJson<String?>(json['userValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int>(blockId),
      'varName': serializer.toJson<String>(varName),
      'defaultValue': serializer.toJson<String?>(defaultValue),
      'userValue': serializer.toJson<String?>(userValue),
    };
  }

  BlockVariable copyWith(
          {int? id,
          int? blockId,
          String? varName,
          Value<String?> defaultValue = const Value.absent(),
          Value<String?> userValue = const Value.absent()}) =>
      BlockVariable(
        id: id ?? this.id,
        blockId: blockId ?? this.blockId,
        varName: varName ?? this.varName,
        defaultValue:
            defaultValue.present ? defaultValue.value : this.defaultValue,
        userValue: userValue.present ? userValue.value : this.userValue,
      );
  BlockVariable copyWithCompanion(BlockVariablesCompanion data) {
    return BlockVariable(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      varName: data.varName.present ? data.varName.value : this.varName,
      defaultValue: data.defaultValue.present
          ? data.defaultValue.value
          : this.defaultValue,
      userValue: data.userValue.present ? data.userValue.value : this.userValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockVariable(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('varName: $varName, ')
          ..write('defaultValue: $defaultValue, ')
          ..write('userValue: $userValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, blockId, varName, defaultValue, userValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockVariable &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.varName == this.varName &&
          other.defaultValue == this.defaultValue &&
          other.userValue == this.userValue);
}

class BlockVariablesCompanion extends UpdateCompanion<BlockVariable> {
  final Value<int> id;
  final Value<int> blockId;
  final Value<String> varName;
  final Value<String?> defaultValue;
  final Value<String?> userValue;
  const BlockVariablesCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.varName = const Value.absent(),
    this.defaultValue = const Value.absent(),
    this.userValue = const Value.absent(),
  });
  BlockVariablesCompanion.insert({
    this.id = const Value.absent(),
    required int blockId,
    required String varName,
    this.defaultValue = const Value.absent(),
    this.userValue = const Value.absent(),
  })  : blockId = Value(blockId),
        varName = Value(varName);
  static Insertable<BlockVariable> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<String>? varName,
    Expression<String>? defaultValue,
    Expression<String>? userValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (varName != null) 'var_name': varName,
      if (defaultValue != null) 'default_value': defaultValue,
      if (userValue != null) 'user_value': userValue,
    });
  }

  BlockVariablesCompanion copyWith(
      {Value<int>? id,
      Value<int>? blockId,
      Value<String>? varName,
      Value<String?>? defaultValue,
      Value<String?>? userValue}) {
    return BlockVariablesCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      varName: varName ?? this.varName,
      defaultValue: defaultValue ?? this.defaultValue,
      userValue: userValue ?? this.userValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (varName.present) {
      map['var_name'] = Variable<String>(varName.value);
    }
    if (defaultValue.present) {
      map['default_value'] = Variable<String>(defaultValue.value);
    }
    if (userValue.present) {
      map['user_value'] = Variable<String>(userValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockVariablesCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('varName: $varName, ')
          ..write('defaultValue: $defaultValue, ')
          ..write('userValue: $userValue')
          ..write(')'))
        .toString();
  }
}

class $SnippetsTable extends Snippets with TableInfo<$SnippetsTable, Snippet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, content, createdAt, updatedAt, lastUsedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets';
  @override
  VerificationContext validateIntegrity(Insertable<Snippet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snippet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snippet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at']),
    );
  }

  @override
  $SnippetsTable createAlias(String alias) {
    return $SnippetsTable(attachedDatabase, alias);
  }
}

class Snippet extends DataClass implements Insertable<Snippet> {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastUsedAt;
  const Snippet(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      this.updatedAt,
      this.lastUsedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    return map;
  }

  SnippetsCompanion toCompanion(bool nullToAbsent) {
    return SnippetsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
    );
  }

  factory Snippet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snippet(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
    };
  }

  Snippet copyWith(
          {int? id,
          String? title,
          String? content,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> lastUsedAt = const Value.absent()}) =>
      Snippet(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
      );
  Snippet copyWithCompanion(SnippetsCompanion data) {
    return Snippet(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snippet(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, createdAt, updatedAt, lastUsedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snippet &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastUsedAt == this.lastUsedAt);
}

class SnippetsCompanion extends UpdateCompanion<Snippet> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> lastUsedAt;
  const SnippetsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  });
  SnippetsCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  });
  static Insertable<Snippet> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastUsedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
    });
  }

  SnippetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? lastUsedAt}) {
    return SnippetsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $PromptsTable prompts = $PromptsTable(this);
  late final $PromptBlocksTable promptBlocks = $PromptBlocksTable(this);
  late final $BlockVariablesTable blockVariables = $BlockVariablesTable(this);
  late final $SnippetsTable snippets = $SnippetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [prompts, promptBlocks, blockVariables, snippets];
}

typedef $$PromptsTableCreateCompanionBuilder = PromptsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> notes,
  Value<String> tags,
  Value<String?> folderPath,
  Value<String> ignorePatterns,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastOpenedAt,
});
typedef $$PromptsTableUpdateCompanionBuilder = PromptsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> notes,
  Value<String> tags,
  Value<String?> folderPath,
  Value<String> ignorePatterns,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastOpenedAt,
});

final class $$PromptsTableReferences
    extends BaseReferences<_$Database, $PromptsTable, Prompt> {
  $$PromptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PromptBlocksTable, List<PromptBlock>>
      _promptBlocksRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
          db.promptBlocks,
          aliasName:
              $_aliasNameGenerator(db.prompts.id, db.promptBlocks.promptId));

  $$PromptBlocksTableProcessedTableManager get promptBlocksRefs {
    final manager = $$PromptBlocksTableTableManager($_db, $_db.promptBlocks)
        .filter((f) => f.promptId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_promptBlocksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PromptsTableFilterComposer extends Composer<_$Database, $PromptsTable> {
  $$PromptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get folderPath => $composableBuilder(
      column: $table.folderPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ignorePatterns => $composableBuilder(
      column: $table.ignorePatterns,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
      column: $table.lastOpenedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> promptBlocksRefs(
      Expression<bool> Function($$PromptBlocksTableFilterComposer f) f) {
    final $$PromptBlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.promptBlocks,
        getReferencedColumn: (t) => t.promptId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PromptBlocksTableFilterComposer(
              $db: $db,
              $table: $db.promptBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PromptsTableOrderingComposer
    extends Composer<_$Database, $PromptsTable> {
  $$PromptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get folderPath => $composableBuilder(
      column: $table.folderPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ignorePatterns => $composableBuilder(
      column: $table.ignorePatterns,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
      column: $table.lastOpenedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$PromptsTableAnnotationComposer
    extends Composer<_$Database, $PromptsTable> {
  $$PromptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get folderPath => $composableBuilder(
      column: $table.folderPath, builder: (column) => column);

  GeneratedColumn<String> get ignorePatterns => $composableBuilder(
      column: $table.ignorePatterns, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
      column: $table.lastOpenedAt, builder: (column) => column);

  Expression<T> promptBlocksRefs<T extends Object>(
      Expression<T> Function($$PromptBlocksTableAnnotationComposer a) f) {
    final $$PromptBlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.promptBlocks,
        getReferencedColumn: (t) => t.promptId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PromptBlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.promptBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PromptsTableTableManager extends RootTableManager<
    _$Database,
    $PromptsTable,
    Prompt,
    $$PromptsTableFilterComposer,
    $$PromptsTableOrderingComposer,
    $$PromptsTableAnnotationComposer,
    $$PromptsTableCreateCompanionBuilder,
    $$PromptsTableUpdateCompanionBuilder,
    (Prompt, $$PromptsTableReferences),
    Prompt,
    PrefetchHooks Function({bool promptBlocksRefs})> {
  $$PromptsTableTableManager(_$Database db, $PromptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> folderPath = const Value.absent(),
            Value<String> ignorePatterns = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastOpenedAt = const Value.absent(),
          }) =>
              PromptsCompanion(
            id: id,
            title: title,
            notes: notes,
            tags: tags,
            folderPath: folderPath,
            ignorePatterns: ignorePatterns,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastOpenedAt: lastOpenedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> folderPath = const Value.absent(),
            Value<String> ignorePatterns = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastOpenedAt = const Value.absent(),
          }) =>
              PromptsCompanion.insert(
            id: id,
            title: title,
            notes: notes,
            tags: tags,
            folderPath: folderPath,
            ignorePatterns: ignorePatterns,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastOpenedAt: lastOpenedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PromptsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({promptBlocksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (promptBlocksRefs) db.promptBlocks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (promptBlocksRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PromptsTableReferences._promptBlocksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PromptsTableReferences(db, table, p0)
                                .promptBlocksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.promptId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PromptsTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $PromptsTable,
    Prompt,
    $$PromptsTableFilterComposer,
    $$PromptsTableOrderingComposer,
    $$PromptsTableAnnotationComposer,
    $$PromptsTableCreateCompanionBuilder,
    $$PromptsTableUpdateCompanionBuilder,
    (Prompt, $$PromptsTableReferences),
    Prompt,
    PrefetchHooks Function({bool promptBlocksRefs})>;
typedef $$PromptBlocksTableCreateCompanionBuilder = PromptBlocksCompanion
    Function({
  Value<int> id,
  required int promptId,
  Value<double> sortOrder,
  required String blockType,
  Value<String> displayName,
  Value<int?> textContentTokenCount,
  Value<int?> summaryTokenCount,
  Value<int?> transcriptTokenCount,
  Value<int?> captionTokenCount,
  Value<String?> textContent,
  Value<String?> filePath,
  Value<String?> mimeType,
  Value<int?> fileSize,
  Value<String?> url,
  Value<String?> transcript,
  Value<String?> caption,
  Value<String?> summary,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$PromptBlocksTableUpdateCompanionBuilder = PromptBlocksCompanion
    Function({
  Value<int> id,
  Value<int> promptId,
  Value<double> sortOrder,
  Value<String> blockType,
  Value<String> displayName,
  Value<int?> textContentTokenCount,
  Value<int?> summaryTokenCount,
  Value<int?> transcriptTokenCount,
  Value<int?> captionTokenCount,
  Value<String?> textContent,
  Value<String?> filePath,
  Value<String?> mimeType,
  Value<int?> fileSize,
  Value<String?> url,
  Value<String?> transcript,
  Value<String?> caption,
  Value<String?> summary,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

final class $$PromptBlocksTableReferences
    extends BaseReferences<_$Database, $PromptBlocksTable, PromptBlock> {
  $$PromptBlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PromptsTable _promptIdTable(_$Database db) => db.prompts.createAlias(
      $_aliasNameGenerator(db.promptBlocks.promptId, db.prompts.id));

  $$PromptsTableProcessedTableManager get promptId {
    final manager = $$PromptsTableTableManager($_db, $_db.prompts)
        .filter((f) => f.id($_item.promptId!));
    final item = $_typedResult.readTableOrNull(_promptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BlockVariablesTable, List<BlockVariable>>
      _blockVariablesRefsTable(_$Database db) =>
          MultiTypedResultKey.fromTable(db.blockVariables,
              aliasName: $_aliasNameGenerator(
                  db.promptBlocks.id, db.blockVariables.blockId));

  $$BlockVariablesTableProcessedTableManager get blockVariablesRefs {
    final manager = $$BlockVariablesTableTableManager($_db, $_db.blockVariables)
        .filter((f) => f.blockId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_blockVariablesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PromptBlocksTableFilterComposer
    extends Composer<_$Database, $PromptBlocksTable> {
  $$PromptBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blockType => $composableBuilder(
      column: $table.blockType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get textContentTokenCount => $composableBuilder(
      column: $table.textContentTokenCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get summaryTokenCount => $composableBuilder(
      column: $table.summaryTokenCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get transcriptTokenCount => $composableBuilder(
      column: $table.transcriptTokenCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get captionTokenCount => $composableBuilder(
      column: $table.captionTokenCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$PromptsTableFilterComposer get promptId {
    final $$PromptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.promptId,
        referencedTable: $db.prompts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PromptsTableFilterComposer(
              $db: $db,
              $table: $db.prompts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> blockVariablesRefs(
      Expression<bool> Function($$BlockVariablesTableFilterComposer f) f) {
    final $$BlockVariablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blockVariables,
        getReferencedColumn: (t) => t.blockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockVariablesTableFilterComposer(
              $db: $db,
              $table: $db.blockVariables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PromptBlocksTableOrderingComposer
    extends Composer<_$Database, $PromptBlocksTable> {
  $$PromptBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blockType => $composableBuilder(
      column: $table.blockType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get textContentTokenCount => $composableBuilder(
      column: $table.textContentTokenCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get summaryTokenCount => $composableBuilder(
      column: $table.summaryTokenCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transcriptTokenCount => $composableBuilder(
      column: $table.transcriptTokenCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get captionTokenCount => $composableBuilder(
      column: $table.captionTokenCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$PromptsTableOrderingComposer get promptId {
    final $$PromptsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.promptId,
        referencedTable: $db.prompts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PromptsTableOrderingComposer(
              $db: $db,
              $table: $db.prompts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PromptBlocksTableAnnotationComposer
    extends Composer<_$Database, $PromptBlocksTable> {
  $$PromptBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get blockType =>
      $composableBuilder(column: $table.blockType, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<int> get textContentTokenCount => $composableBuilder(
      column: $table.textContentTokenCount, builder: (column) => column);

  GeneratedColumn<int> get summaryTokenCount => $composableBuilder(
      column: $table.summaryTokenCount, builder: (column) => column);

  GeneratedColumn<int> get transcriptTokenCount => $composableBuilder(
      column: $table.transcriptTokenCount, builder: (column) => column);

  GeneratedColumn<int> get captionTokenCount => $composableBuilder(
      column: $table.captionTokenCount, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PromptsTableAnnotationComposer get promptId {
    final $$PromptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.promptId,
        referencedTable: $db.prompts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PromptsTableAnnotationComposer(
              $db: $db,
              $table: $db.prompts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> blockVariablesRefs<T extends Object>(
      Expression<T> Function($$BlockVariablesTableAnnotationComposer a) f) {
    final $$BlockVariablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blockVariables,
        getReferencedColumn: (t) => t.blockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockVariablesTableAnnotationComposer(
              $db: $db,
              $table: $db.blockVariables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PromptBlocksTableTableManager extends RootTableManager<
    _$Database,
    $PromptBlocksTable,
    PromptBlock,
    $$PromptBlocksTableFilterComposer,
    $$PromptBlocksTableOrderingComposer,
    $$PromptBlocksTableAnnotationComposer,
    $$PromptBlocksTableCreateCompanionBuilder,
    $$PromptBlocksTableUpdateCompanionBuilder,
    (PromptBlock, $$PromptBlocksTableReferences),
    PromptBlock,
    PrefetchHooks Function({bool promptId, bool blockVariablesRefs})> {
  $$PromptBlocksTableTableManager(_$Database db, $PromptBlocksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromptBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromptBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromptBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> promptId = const Value.absent(),
            Value<double> sortOrder = const Value.absent(),
            Value<String> blockType = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<int?> textContentTokenCount = const Value.absent(),
            Value<int?> summaryTokenCount = const Value.absent(),
            Value<int?> transcriptTokenCount = const Value.absent(),
            Value<int?> captionTokenCount = const Value.absent(),
            Value<String?> textContent = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<int?> fileSize = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<String?> transcript = const Value.absent(),
            Value<String?> caption = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PromptBlocksCompanion(
            id: id,
            promptId: promptId,
            sortOrder: sortOrder,
            blockType: blockType,
            displayName: displayName,
            textContentTokenCount: textContentTokenCount,
            summaryTokenCount: summaryTokenCount,
            transcriptTokenCount: transcriptTokenCount,
            captionTokenCount: captionTokenCount,
            textContent: textContent,
            filePath: filePath,
            mimeType: mimeType,
            fileSize: fileSize,
            url: url,
            transcript: transcript,
            caption: caption,
            summary: summary,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int promptId,
            Value<double> sortOrder = const Value.absent(),
            required String blockType,
            Value<String> displayName = const Value.absent(),
            Value<int?> textContentTokenCount = const Value.absent(),
            Value<int?> summaryTokenCount = const Value.absent(),
            Value<int?> transcriptTokenCount = const Value.absent(),
            Value<int?> captionTokenCount = const Value.absent(),
            Value<String?> textContent = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<int?> fileSize = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<String?> transcript = const Value.absent(),
            Value<String?> caption = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PromptBlocksCompanion.insert(
            id: id,
            promptId: promptId,
            sortOrder: sortOrder,
            blockType: blockType,
            displayName: displayName,
            textContentTokenCount: textContentTokenCount,
            summaryTokenCount: summaryTokenCount,
            transcriptTokenCount: transcriptTokenCount,
            captionTokenCount: captionTokenCount,
            textContent: textContent,
            filePath: filePath,
            mimeType: mimeType,
            fileSize: fileSize,
            url: url,
            transcript: transcript,
            caption: caption,
            summary: summary,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PromptBlocksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {promptId = false, blockVariablesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (blockVariablesRefs) db.blockVariables
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (promptId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.promptId,
                    referencedTable:
                        $$PromptBlocksTableReferences._promptIdTable(db),
                    referencedColumn:
                        $$PromptBlocksTableReferences._promptIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (blockVariablesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PromptBlocksTableReferences
                            ._blockVariablesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PromptBlocksTableReferences(db, table, p0)
                                .blockVariablesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.blockId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PromptBlocksTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $PromptBlocksTable,
    PromptBlock,
    $$PromptBlocksTableFilterComposer,
    $$PromptBlocksTableOrderingComposer,
    $$PromptBlocksTableAnnotationComposer,
    $$PromptBlocksTableCreateCompanionBuilder,
    $$PromptBlocksTableUpdateCompanionBuilder,
    (PromptBlock, $$PromptBlocksTableReferences),
    PromptBlock,
    PrefetchHooks Function({bool promptId, bool blockVariablesRefs})>;
typedef $$BlockVariablesTableCreateCompanionBuilder = BlockVariablesCompanion
    Function({
  Value<int> id,
  required int blockId,
  required String varName,
  Value<String?> defaultValue,
  Value<String?> userValue,
});
typedef $$BlockVariablesTableUpdateCompanionBuilder = BlockVariablesCompanion
    Function({
  Value<int> id,
  Value<int> blockId,
  Value<String> varName,
  Value<String?> defaultValue,
  Value<String?> userValue,
});

final class $$BlockVariablesTableReferences
    extends BaseReferences<_$Database, $BlockVariablesTable, BlockVariable> {
  $$BlockVariablesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PromptBlocksTable _blockIdTable(_$Database db) =>
      db.promptBlocks.createAlias(
          $_aliasNameGenerator(db.blockVariables.blockId, db.promptBlocks.id));

  $$PromptBlocksTableProcessedTableManager get blockId {
    final manager = $$PromptBlocksTableTableManager($_db, $_db.promptBlocks)
        .filter((f) => f.id($_item.blockId!));
    final item = $_typedResult.readTableOrNull(_blockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BlockVariablesTableFilterComposer
    extends Composer<_$Database, $BlockVariablesTable> {
  $$BlockVariablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get varName => $composableBuilder(
      column: $table.varName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userValue => $composableBuilder(
      column: $table.userValue, builder: (column) => ColumnFilters(column));

  $$PromptBlocksTableFilterComposer get blockId {
    final $$PromptBlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockId,
        referencedTable: $db.promptBlocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PromptBlocksTableFilterComposer(
              $db: $db,
              $table: $db.promptBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlockVariablesTableOrderingComposer
    extends Composer<_$Database, $BlockVariablesTable> {
  $$BlockVariablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get varName => $composableBuilder(
      column: $table.varName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userValue => $composableBuilder(
      column: $table.userValue, builder: (column) => ColumnOrderings(column));

  $$PromptBlocksTableOrderingComposer get blockId {
    final $$PromptBlocksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockId,
        referencedTable: $db.promptBlocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PromptBlocksTableOrderingComposer(
              $db: $db,
              $table: $db.promptBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlockVariablesTableAnnotationComposer
    extends Composer<_$Database, $BlockVariablesTable> {
  $$BlockVariablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get varName =>
      $composableBuilder(column: $table.varName, builder: (column) => column);

  GeneratedColumn<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue, builder: (column) => column);

  GeneratedColumn<String> get userValue =>
      $composableBuilder(column: $table.userValue, builder: (column) => column);

  $$PromptBlocksTableAnnotationComposer get blockId {
    final $$PromptBlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockId,
        referencedTable: $db.promptBlocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PromptBlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.promptBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlockVariablesTableTableManager extends RootTableManager<
    _$Database,
    $BlockVariablesTable,
    BlockVariable,
    $$BlockVariablesTableFilterComposer,
    $$BlockVariablesTableOrderingComposer,
    $$BlockVariablesTableAnnotationComposer,
    $$BlockVariablesTableCreateCompanionBuilder,
    $$BlockVariablesTableUpdateCompanionBuilder,
    (BlockVariable, $$BlockVariablesTableReferences),
    BlockVariable,
    PrefetchHooks Function({bool blockId})> {
  $$BlockVariablesTableTableManager(_$Database db, $BlockVariablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockVariablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockVariablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockVariablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> blockId = const Value.absent(),
            Value<String> varName = const Value.absent(),
            Value<String?> defaultValue = const Value.absent(),
            Value<String?> userValue = const Value.absent(),
          }) =>
              BlockVariablesCompanion(
            id: id,
            blockId: blockId,
            varName: varName,
            defaultValue: defaultValue,
            userValue: userValue,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int blockId,
            required String varName,
            Value<String?> defaultValue = const Value.absent(),
            Value<String?> userValue = const Value.absent(),
          }) =>
              BlockVariablesCompanion.insert(
            id: id,
            blockId: blockId,
            varName: varName,
            defaultValue: defaultValue,
            userValue: userValue,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BlockVariablesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({blockId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (blockId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.blockId,
                    referencedTable:
                        $$BlockVariablesTableReferences._blockIdTable(db),
                    referencedColumn:
                        $$BlockVariablesTableReferences._blockIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BlockVariablesTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $BlockVariablesTable,
    BlockVariable,
    $$BlockVariablesTableFilterComposer,
    $$BlockVariablesTableOrderingComposer,
    $$BlockVariablesTableAnnotationComposer,
    $$BlockVariablesTableCreateCompanionBuilder,
    $$BlockVariablesTableUpdateCompanionBuilder,
    (BlockVariable, $$BlockVariablesTableReferences),
    BlockVariable,
    PrefetchHooks Function({bool blockId})>;
typedef $$SnippetsTableCreateCompanionBuilder = SnippetsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastUsedAt,
});
typedef $$SnippetsTableUpdateCompanionBuilder = SnippetsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastUsedAt,
});

class $$SnippetsTableFilterComposer
    extends Composer<_$Database, $SnippetsTable> {
  $$SnippetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));
}

class $$SnippetsTableOrderingComposer
    extends Composer<_$Database, $SnippetsTable> {
  $$SnippetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));
}

class $$SnippetsTableAnnotationComposer
    extends Composer<_$Database, $SnippetsTable> {
  $$SnippetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);
}

class $$SnippetsTableTableManager extends RootTableManager<
    _$Database,
    $SnippetsTable,
    Snippet,
    $$SnippetsTableFilterComposer,
    $$SnippetsTableOrderingComposer,
    $$SnippetsTableAnnotationComposer,
    $$SnippetsTableCreateCompanionBuilder,
    $$SnippetsTableUpdateCompanionBuilder,
    (Snippet, BaseReferences<_$Database, $SnippetsTable, Snippet>),
    Snippet,
    PrefetchHooks Function()> {
  $$SnippetsTableTableManager(_$Database db, $SnippetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
          }) =>
              SnippetsCompanion(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastUsedAt: lastUsedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
          }) =>
              SnippetsCompanion.insert(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastUsedAt: lastUsedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnippetsTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $SnippetsTable,
    Snippet,
    $$SnippetsTableFilterComposer,
    $$SnippetsTableOrderingComposer,
    $$SnippetsTableAnnotationComposer,
    $$SnippetsTableCreateCompanionBuilder,
    $$SnippetsTableUpdateCompanionBuilder,
    (Snippet, BaseReferences<_$Database, $SnippetsTable, Snippet>),
    Snippet,
    PrefetchHooks Function()>;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$PromptsTableTableManager get prompts =>
      $$PromptsTableTableManager(_db, _db.prompts);
  $$PromptBlocksTableTableManager get promptBlocks =>
      $$PromptBlocksTableTableManager(_db, _db.promptBlocks);
  $$BlockVariablesTableTableManager get blockVariables =>
      $$BlockVariablesTableTableManager(_db, _db.blockVariables);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db, _db.snippets);
}
