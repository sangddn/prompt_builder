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
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, folderPath, ignorePatterns, createdAt, updatedAt];
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
      folderPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_path']),
      ignorePatterns: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ignore_patterns'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
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
  final String? folderPath;
  final String ignorePatterns;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Prompt(
      {required this.id,
      required this.title,
      this.folderPath,
      required this.ignorePatterns,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || folderPath != null) {
      map['folder_path'] = Variable<String>(folderPath);
    }
    map['ignore_patterns'] = Variable<String>(ignorePatterns);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PromptsCompanion toCompanion(bool nullToAbsent) {
    return PromptsCompanion(
      id: Value(id),
      title: Value(title),
      folderPath: folderPath == null && nullToAbsent
          ? const Value.absent()
          : Value(folderPath),
      ignorePatterns: Value(ignorePatterns),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Prompt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prompt(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      folderPath: serializer.fromJson<String?>(json['folderPath']),
      ignorePatterns: serializer.fromJson<String>(json['ignorePatterns']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'folderPath': serializer.toJson<String?>(folderPath),
      'ignorePatterns': serializer.toJson<String>(ignorePatterns),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Prompt copyWith(
          {int? id,
          String? title,
          Value<String?> folderPath = const Value.absent(),
          String? ignorePatterns,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Prompt(
        id: id ?? this.id,
        title: title ?? this.title,
        folderPath: folderPath.present ? folderPath.value : this.folderPath,
        ignorePatterns: ignorePatterns ?? this.ignorePatterns,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Prompt copyWithCompanion(PromptsCompanion data) {
    return Prompt(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      folderPath:
          data.folderPath.present ? data.folderPath.value : this.folderPath,
      ignorePatterns: data.ignorePatterns.present
          ? data.ignorePatterns.value
          : this.ignorePatterns,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prompt(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('folderPath: $folderPath, ')
          ..write('ignorePatterns: $ignorePatterns, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, folderPath, ignorePatterns, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prompt &&
          other.id == this.id &&
          other.title == this.title &&
          other.folderPath == this.folderPath &&
          other.ignorePatterns == this.ignorePatterns &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PromptsCompanion extends UpdateCompanion<Prompt> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> folderPath;
  final Value<String> ignorePatterns;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const PromptsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.ignorePatterns = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PromptsCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.ignorePatterns = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Prompt> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? folderPath,
    Expression<String>? ignorePatterns,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (folderPath != null) 'folder_path': folderPath,
      if (ignorePatterns != null) 'ignore_patterns': ignorePatterns,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PromptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? folderPath,
      Value<String>? ignorePatterns,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return PromptsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      folderPath: folderPath ?? this.folderPath,
      ignorePatterns: ignorePatterns ?? this.ignorePatterns,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromptsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('folderPath: $folderPath, ')
          ..write('ignorePatterns: $ignorePatterns, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
      $customConstraints: 'REFERENCES prompts(id)');
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
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
  static const VerificationMeta _tokenCountMeta =
      const VerificationMeta('tokenCount');
  @override
  late final GeneratedColumn<int> tokenCount = GeneratedColumn<int>(
      'token_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
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
        tokenCount,
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
    if (data.containsKey('token_count')) {
      context.handle(
          _tokenCountMeta,
          tokenCount.isAcceptableOrUnknown(
              data['token_count']!, _tokenCountMeta));
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
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      blockType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}block_type'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      tokenCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}token_count'])!,
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
  final int sortOrder;

  /// The type of content in this block, stored as a string representation
  /// of the [BlockType] enum
  final String blockType;

  /// User-facing name/title for this block
  final String displayName;

  /// Number of tokens in this block's content, used for API limits
  final int tokenCount;

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
      required this.tokenCount,
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
    map['sort_order'] = Variable<int>(sortOrder);
    map['block_type'] = Variable<String>(blockType);
    map['display_name'] = Variable<String>(displayName);
    map['token_count'] = Variable<int>(tokenCount);
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
      tokenCount: Value(tokenCount),
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
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      blockType: serializer.fromJson<String>(json['blockType']),
      displayName: serializer.fromJson<String>(json['displayName']),
      tokenCount: serializer.fromJson<int>(json['tokenCount']),
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
      'sortOrder': serializer.toJson<int>(sortOrder),
      'blockType': serializer.toJson<String>(blockType),
      'displayName': serializer.toJson<String>(displayName),
      'tokenCount': serializer.toJson<int>(tokenCount),
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
          int? sortOrder,
          String? blockType,
          String? displayName,
          int? tokenCount,
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
        tokenCount: tokenCount ?? this.tokenCount,
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
      tokenCount:
          data.tokenCount.present ? data.tokenCount.value : this.tokenCount,
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
          ..write('tokenCount: $tokenCount, ')
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
      tokenCount,
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
          other.tokenCount == this.tokenCount &&
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
  final Value<int> sortOrder;
  final Value<String> blockType;
  final Value<String> displayName;
  final Value<int> tokenCount;
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
    this.tokenCount = const Value.absent(),
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
    this.tokenCount = const Value.absent(),
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
    Expression<int>? sortOrder,
    Expression<String>? blockType,
    Expression<String>? displayName,
    Expression<int>? tokenCount,
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
      if (tokenCount != null) 'token_count': tokenCount,
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
      Value<int>? sortOrder,
      Value<String>? blockType,
      Value<String>? displayName,
      Value<int>? tokenCount,
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
      tokenCount: tokenCount ?? this.tokenCount,
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
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (blockType.present) {
      map['block_type'] = Variable<String>(blockType.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (tokenCount.present) {
      map['token_count'] = Variable<int>(tokenCount.value);
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
          ..write('tokenCount: $tokenCount, ')
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
      $customConstraints: 'REFERENCES prompt_blocks(id)');
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

abstract class _$_AppDatabase extends GeneratedDatabase {
  _$_AppDatabase(QueryExecutor e) : super(e);
  $_AppDatabaseManager get managers => $_AppDatabaseManager(this);
  late final $PromptsTable prompts = $PromptsTable(this);
  late final $PromptBlocksTable promptBlocks = $PromptBlocksTable(this);
  late final $BlockVariablesTable blockVariables = $BlockVariablesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [prompts, promptBlocks, blockVariables];
}

typedef $$PromptsTableCreateCompanionBuilder = PromptsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> folderPath,
  Value<String> ignorePatterns,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$PromptsTableUpdateCompanionBuilder = PromptsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> folderPath,
  Value<String> ignorePatterns,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

class $$PromptsTableFilterComposer
    extends Composer<_$_AppDatabase, $PromptsTable> {
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

  ColumnFilters<String> get folderPath => $composableBuilder(
      column: $table.folderPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ignorePatterns => $composableBuilder(
      column: $table.ignorePatterns,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PromptsTableOrderingComposer
    extends Composer<_$_AppDatabase, $PromptsTable> {
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

  ColumnOrderings<String> get folderPath => $composableBuilder(
      column: $table.folderPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ignorePatterns => $composableBuilder(
      column: $table.ignorePatterns,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PromptsTableAnnotationComposer
    extends Composer<_$_AppDatabase, $PromptsTable> {
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

  GeneratedColumn<String> get folderPath => $composableBuilder(
      column: $table.folderPath, builder: (column) => column);

  GeneratedColumn<String> get ignorePatterns => $composableBuilder(
      column: $table.ignorePatterns, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PromptsTableTableManager extends RootTableManager<
    _$_AppDatabase,
    $PromptsTable,
    Prompt,
    $$PromptsTableFilterComposer,
    $$PromptsTableOrderingComposer,
    $$PromptsTableAnnotationComposer,
    $$PromptsTableCreateCompanionBuilder,
    $$PromptsTableUpdateCompanionBuilder,
    (Prompt, BaseReferences<_$_AppDatabase, $PromptsTable, Prompt>),
    Prompt,
    PrefetchHooks Function()> {
  $$PromptsTableTableManager(_$_AppDatabase db, $PromptsTable table)
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
            Value<String?> folderPath = const Value.absent(),
            Value<String> ignorePatterns = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PromptsCompanion(
            id: id,
            title: title,
            folderPath: folderPath,
            ignorePatterns: ignorePatterns,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> folderPath = const Value.absent(),
            Value<String> ignorePatterns = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PromptsCompanion.insert(
            id: id,
            title: title,
            folderPath: folderPath,
            ignorePatterns: ignorePatterns,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PromptsTableProcessedTableManager = ProcessedTableManager<
    _$_AppDatabase,
    $PromptsTable,
    Prompt,
    $$PromptsTableFilterComposer,
    $$PromptsTableOrderingComposer,
    $$PromptsTableAnnotationComposer,
    $$PromptsTableCreateCompanionBuilder,
    $$PromptsTableUpdateCompanionBuilder,
    (Prompt, BaseReferences<_$_AppDatabase, $PromptsTable, Prompt>),
    Prompt,
    PrefetchHooks Function()>;
typedef $$PromptBlocksTableCreateCompanionBuilder = PromptBlocksCompanion
    Function({
  Value<int> id,
  required int promptId,
  Value<int> sortOrder,
  required String blockType,
  Value<String> displayName,
  Value<int> tokenCount,
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
  Value<int> sortOrder,
  Value<String> blockType,
  Value<String> displayName,
  Value<int> tokenCount,
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

class $$PromptBlocksTableFilterComposer
    extends Composer<_$_AppDatabase, $PromptBlocksTable> {
  $$PromptBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get promptId => $composableBuilder(
      column: $table.promptId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blockType => $composableBuilder(
      column: $table.blockType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => ColumnFilters(column));

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
}

class $$PromptBlocksTableOrderingComposer
    extends Composer<_$_AppDatabase, $PromptBlocksTable> {
  $$PromptBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get promptId => $composableBuilder(
      column: $table.promptId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blockType => $composableBuilder(
      column: $table.blockType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => ColumnOrderings(column));

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
}

class $$PromptBlocksTableAnnotationComposer
    extends Composer<_$_AppDatabase, $PromptBlocksTable> {
  $$PromptBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get promptId =>
      $composableBuilder(column: $table.promptId, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get blockType =>
      $composableBuilder(column: $table.blockType, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => column);

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
}

class $$PromptBlocksTableTableManager extends RootTableManager<
    _$_AppDatabase,
    $PromptBlocksTable,
    PromptBlock,
    $$PromptBlocksTableFilterComposer,
    $$PromptBlocksTableOrderingComposer,
    $$PromptBlocksTableAnnotationComposer,
    $$PromptBlocksTableCreateCompanionBuilder,
    $$PromptBlocksTableUpdateCompanionBuilder,
    (
      PromptBlock,
      BaseReferences<_$_AppDatabase, $PromptBlocksTable, PromptBlock>
    ),
    PromptBlock,
    PrefetchHooks Function()> {
  $$PromptBlocksTableTableManager(_$_AppDatabase db, $PromptBlocksTable table)
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
            Value<int> sortOrder = const Value.absent(),
            Value<String> blockType = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<int> tokenCount = const Value.absent(),
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
            tokenCount: tokenCount,
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
            Value<int> sortOrder = const Value.absent(),
            required String blockType,
            Value<String> displayName = const Value.absent(),
            Value<int> tokenCount = const Value.absent(),
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
            tokenCount: tokenCount,
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PromptBlocksTableProcessedTableManager = ProcessedTableManager<
    _$_AppDatabase,
    $PromptBlocksTable,
    PromptBlock,
    $$PromptBlocksTableFilterComposer,
    $$PromptBlocksTableOrderingComposer,
    $$PromptBlocksTableAnnotationComposer,
    $$PromptBlocksTableCreateCompanionBuilder,
    $$PromptBlocksTableUpdateCompanionBuilder,
    (
      PromptBlock,
      BaseReferences<_$_AppDatabase, $PromptBlocksTable, PromptBlock>
    ),
    PromptBlock,
    PrefetchHooks Function()>;
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

class $$BlockVariablesTableFilterComposer
    extends Composer<_$_AppDatabase, $BlockVariablesTable> {
  $$BlockVariablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get blockId => $composableBuilder(
      column: $table.blockId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get varName => $composableBuilder(
      column: $table.varName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userValue => $composableBuilder(
      column: $table.userValue, builder: (column) => ColumnFilters(column));
}

class $$BlockVariablesTableOrderingComposer
    extends Composer<_$_AppDatabase, $BlockVariablesTable> {
  $$BlockVariablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get blockId => $composableBuilder(
      column: $table.blockId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get varName => $composableBuilder(
      column: $table.varName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userValue => $composableBuilder(
      column: $table.userValue, builder: (column) => ColumnOrderings(column));
}

class $$BlockVariablesTableAnnotationComposer
    extends Composer<_$_AppDatabase, $BlockVariablesTable> {
  $$BlockVariablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get blockId =>
      $composableBuilder(column: $table.blockId, builder: (column) => column);

  GeneratedColumn<String> get varName =>
      $composableBuilder(column: $table.varName, builder: (column) => column);

  GeneratedColumn<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue, builder: (column) => column);

  GeneratedColumn<String> get userValue =>
      $composableBuilder(column: $table.userValue, builder: (column) => column);
}

class $$BlockVariablesTableTableManager extends RootTableManager<
    _$_AppDatabase,
    $BlockVariablesTable,
    BlockVariable,
    $$BlockVariablesTableFilterComposer,
    $$BlockVariablesTableOrderingComposer,
    $$BlockVariablesTableAnnotationComposer,
    $$BlockVariablesTableCreateCompanionBuilder,
    $$BlockVariablesTableUpdateCompanionBuilder,
    (
      BlockVariable,
      BaseReferences<_$_AppDatabase, $BlockVariablesTable, BlockVariable>
    ),
    BlockVariable,
    PrefetchHooks Function()> {
  $$BlockVariablesTableTableManager(
      _$_AppDatabase db, $BlockVariablesTable table)
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BlockVariablesTableProcessedTableManager = ProcessedTableManager<
    _$_AppDatabase,
    $BlockVariablesTable,
    BlockVariable,
    $$BlockVariablesTableFilterComposer,
    $$BlockVariablesTableOrderingComposer,
    $$BlockVariablesTableAnnotationComposer,
    $$BlockVariablesTableCreateCompanionBuilder,
    $$BlockVariablesTableUpdateCompanionBuilder,
    (
      BlockVariable,
      BaseReferences<_$_AppDatabase, $BlockVariablesTable, BlockVariable>
    ),
    BlockVariable,
    PrefetchHooks Function()>;

class $_AppDatabaseManager {
  final _$_AppDatabase _db;
  $_AppDatabaseManager(this._db);
  $$PromptsTableTableManager get prompts =>
      $$PromptsTableTableManager(_db, _db.prompts);
  $$PromptBlocksTableTableManager get promptBlocks =>
      $$PromptBlocksTableTableManager(_db, _db.promptBlocks);
  $$BlockVariablesTableTableManager get blockVariables =>
      $$BlockVariablesTableTableManager(_db, _db.blockVariables);
}
