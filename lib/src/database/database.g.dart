// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
      [id, title, notes, emoji, color, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
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
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
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
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  /// Primary key and unique identifier for the project
  final int id;

  /// User-defined title of the project
  final String title;

  /// User notes/description for the project
  final String notes;

  /// Emoji icon for the project (stored as unicode string)
  final String? emoji;

  /// Color for the project (stored as integer ARGB)
  final int? color;

  /// When the project was created
  final DateTime createdAt;

  /// When the project was last modified
  final DateTime? updatedAt;
  const Project(
      {required this.id,
      required this.title,
      required this.notes,
      this.emoji,
      this.color,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      title: Value(title),
      notes: Value(notes),
      emoji:
          emoji == null && nullToAbsent ? const Value.absent() : Value(emoji),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String>(json['notes']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      color: serializer.fromJson<int?>(json['color']),
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
      'notes': serializer.toJson<String>(notes),
      'emoji': serializer.toJson<String?>(emoji),
      'color': serializer.toJson<int?>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Project copyWith(
          {int? id,
          String? title,
          String? notes,
          Value<String?> emoji = const Value.absent(),
          Value<int?> color = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Project(
        id: id ?? this.id,
        title: title ?? this.title,
        notes: notes ?? this.notes,
        emoji: emoji.present ? emoji.value : this.emoji,
        color: color.present ? color.value : this.color,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('emoji: $emoji, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, notes, emoji, color, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.emoji == this.emoji &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> notes;
  final Value<String?> emoji;
  final Value<int?> color;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.emoji = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.emoji = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? emoji,
    Expression<int>? color,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (emoji != null) 'emoji': emoji,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? notes,
      Value<String?>? emoji,
      Value<int?>? color,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
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
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
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
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('emoji: $emoji, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

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
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
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
  static const VerificationMeta _chatUrlMeta =
      const VerificationMeta('chatUrl');
  @override
  late final GeneratedColumn<String> chatUrl = GeneratedColumn<String>(
      'chat_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        projectId,
        title,
        notes,
        chatUrl,
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
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('chat_url')) {
      context.handle(_chatUrlMeta,
          chatUrl.isAcceptableOrUnknown(data['chat_url']!, _chatUrlMeta));
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
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      chatUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_url']),
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
  /// Primary key for the prompt.
  final int id;

  /// Optional reference to a project in the [Projects] table.
  ///
  /// When null, the prompt is not associated with any specific project.
  final int? projectId;

  /// User-defined title for the prompt.
  ///
  /// Defaults to an empty string if not specified.
  final String title;

  /// Additional notes or description for the prompt.
  ///
  /// Defaults to an empty string if not specified.
  final String notes;

  /// The URL to the chat associated with the prompt, if any.
  final String? chatUrl;

  /// "|"-separated list of tags for categorizing the prompt.
  ///
  /// Defaults to an empty string if not specified.
  final String tags;

  /// Optional directory path associated with the prompt.
  ///
  /// When specified, indicates a folder that should be opened or processed
  /// when using this prompt.
  final String? folderPath;

  /// Patterns for excluding files when processing the folder path.
  ///
  /// Defaults to an empty string if not specified. Multiple patterns
  /// should be separated by newlines.
  final String ignorePatterns;

  /// Timestamp when the prompt was created.
  ///
  /// Automatically set to the current date and time when creating a new prompt.
  final DateTime createdAt;

  /// Timestamp when the prompt was last modified.
  ///
  /// Null if the prompt has never been modified after creation.
  final DateTime? updatedAt;

  /// Timestamp when the prompt was last opened or used.
  ///
  /// Null if the prompt has never been opened.
  final DateTime? lastOpenedAt;
  const Prompt(
      {required this.id,
      this.projectId,
      required this.title,
      required this.notes,
      this.chatUrl,
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
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    map['title'] = Variable<String>(title);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || chatUrl != null) {
      map['chat_url'] = Variable<String>(chatUrl);
    }
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
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      title: Value(title),
      notes: Value(notes),
      chatUrl: chatUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(chatUrl),
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
      projectId: serializer.fromJson<int?>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String>(json['notes']),
      chatUrl: serializer.fromJson<String?>(json['chatUrl']),
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
      'projectId': serializer.toJson<int?>(projectId),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String>(notes),
      'chatUrl': serializer.toJson<String?>(chatUrl),
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
          Value<int?> projectId = const Value.absent(),
          String? title,
          String? notes,
          Value<String?> chatUrl = const Value.absent(),
          String? tags,
          Value<String?> folderPath = const Value.absent(),
          String? ignorePatterns,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> lastOpenedAt = const Value.absent()}) =>
      Prompt(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        title: title ?? this.title,
        notes: notes ?? this.notes,
        chatUrl: chatUrl.present ? chatUrl.value : this.chatUrl,
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
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      chatUrl: data.chatUrl.present ? data.chatUrl.value : this.chatUrl,
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
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('chatUrl: $chatUrl, ')
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
  int get hashCode => Object.hash(id, projectId, title, notes, chatUrl, tags,
      folderPath, ignorePatterns, createdAt, updatedAt, lastOpenedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prompt &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.chatUrl == this.chatUrl &&
          other.tags == this.tags &&
          other.folderPath == this.folderPath &&
          other.ignorePatterns == this.ignorePatterns &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class PromptsCompanion extends UpdateCompanion<Prompt> {
  final Value<int> id;
  final Value<int?> projectId;
  final Value<String> title;
  final Value<String> notes;
  final Value<String?> chatUrl;
  final Value<String> tags;
  final Value<String?> folderPath;
  final Value<String> ignorePatterns;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> lastOpenedAt;
  const PromptsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.chatUrl = const Value.absent(),
    this.tags = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.ignorePatterns = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  PromptsCompanion.insert({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.chatUrl = const Value.absent(),
    this.tags = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.ignorePatterns = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  static Insertable<Prompt> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? chatUrl,
    Expression<String>? tags,
    Expression<String>? folderPath,
    Expression<String>? ignorePatterns,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastOpenedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (chatUrl != null) 'chat_url': chatUrl,
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
      Value<int?>? projectId,
      Value<String>? title,
      Value<String>? notes,
      Value<String?>? chatUrl,
      Value<String>? tags,
      Value<String?>? folderPath,
      Value<String>? ignorePatterns,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? lastOpenedAt}) {
    return PromptsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      chatUrl: chatUrl ?? this.chatUrl,
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
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (chatUrl.present) {
      map['chat_url'] = Variable<String>(chatUrl.value);
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
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('chatUrl: $chatUrl, ')
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
  static const VerificationMeta _fullContentTokenCountMeta =
      const VerificationMeta('fullContentTokenCount');
  @override
  late final GeneratedColumn<int> fullContentTokenCount = GeneratedColumn<int>(
      'full_content_token_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _summaryTokenCountMeta =
      const VerificationMeta('summaryTokenCount');
  @override
  late final GeneratedColumn<int> summaryTokenCount = GeneratedColumn<int>(
      'summary_token_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fullContentTokenCountMethodMeta =
      const VerificationMeta('fullContentTokenCountMethod');
  @override
  late final GeneratedColumn<String> fullContentTokenCountMethod =
      GeneratedColumn<String>(
          'full_content_token_count_method', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _summaryTokenCountMethodMeta =
      const VerificationMeta('summaryTokenCountMethod');
  @override
  late final GeneratedColumn<String> summaryTokenCountMethod =
      GeneratedColumn<String>('summary_token_count_method', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preferSummaryMeta =
      const VerificationMeta('preferSummary');
  @override
  late final GeneratedColumn<bool> preferSummary = GeneratedColumn<bool>(
      'prefer_summary', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("prefer_summary" IN (0, 1))'),
      defaultValue: const Constant(false));
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
        fullContentTokenCount,
        summaryTokenCount,
        fullContentTokenCountMethod,
        summaryTokenCountMethod,
        preferSummary,
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
    if (data.containsKey('full_content_token_count')) {
      context.handle(
          _fullContentTokenCountMeta,
          fullContentTokenCount.isAcceptableOrUnknown(
              data['full_content_token_count']!, _fullContentTokenCountMeta));
    }
    if (data.containsKey('summary_token_count')) {
      context.handle(
          _summaryTokenCountMeta,
          summaryTokenCount.isAcceptableOrUnknown(
              data['summary_token_count']!, _summaryTokenCountMeta));
    }
    if (data.containsKey('full_content_token_count_method')) {
      context.handle(
          _fullContentTokenCountMethodMeta,
          fullContentTokenCountMethod.isAcceptableOrUnknown(
              data['full_content_token_count_method']!,
              _fullContentTokenCountMethodMeta));
    }
    if (data.containsKey('summary_token_count_method')) {
      context.handle(
          _summaryTokenCountMethodMeta,
          summaryTokenCountMethod.isAcceptableOrUnknown(
              data['summary_token_count_method']!,
              _summaryTokenCountMethodMeta));
    }
    if (data.containsKey('prefer_summary')) {
      context.handle(
          _preferSummaryMeta,
          preferSummary.isAcceptableOrUnknown(
              data['prefer_summary']!, _preferSummaryMeta));
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
      fullContentTokenCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}full_content_token_count']),
      summaryTokenCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}summary_token_count']),
      fullContentTokenCountMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}full_content_token_count_method']),
      summaryTokenCountMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}summary_token_count_method']),
      preferSummary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}prefer_summary'])!,
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
  /// Unique identifier for each block.
  final int id;

  /// Reference to the parent prompt this block belongs to.
  final int promptId;

  /// Position of this block within the prompt's sequence of blocks.
  /// Defaults to 0 if not specified.
  final double sortOrder;

  /// The type of content in this block, stored as a string representation
  /// of the [BlockType] enum.
  final String blockType;

  /// User-facing name/title for this block.
  final String displayName;

  /// Number of tokens in this block's copiable full content ([copyToPrompt]
  /// without [preferSummary] set to false).
  final int? fullContentTokenCount;

  /// Number of tokens in this block's summary content ([copyToPrompt] with
  /// [preferSummary] set to true).
  final int? summaryTokenCount;

  /// Method used to count tokens in this block's full content.
  final String? fullContentTokenCountMethod;

  /// Method used to count tokens in this block's summary content.
  final String? summaryTokenCountMethod;

  /// Whether this block, when copied, should prefer the summary content.
  final bool preferSummary;

  /// Main text content for text-based blocks.
  /// Nullable since not all block types contain text.
  final String? textContent;

  /// Local filesystem path or app directory path for file-backed content.
  final String? filePath;

  /// MIME type of the content (e.g. 'application/pdf', 'audio/wav').
  /// Used for proper handling of different file formats.
  final String? mimeType;

  /// Size of the file in bytes, if applicable
  final int? fileSize;

  /// URL for web-based content (YouTube videos, web pages, remote media).
  final String? url;

  /// Transcribed text content for audio/video content.
  final String? transcript;

  /// Caption or alt text for image content.
  final String? caption;

  /// Condensed version of large text content or transcripts.
  final String? summary;

  /// Timestamp when this block was created.
  final DateTime createdAt;

  /// Timestamp when this block was last modified.
  final DateTime? updatedAt;
  const PromptBlock(
      {required this.id,
      required this.promptId,
      required this.sortOrder,
      required this.blockType,
      required this.displayName,
      this.fullContentTokenCount,
      this.summaryTokenCount,
      this.fullContentTokenCountMethod,
      this.summaryTokenCountMethod,
      required this.preferSummary,
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
    if (!nullToAbsent || fullContentTokenCount != null) {
      map['full_content_token_count'] = Variable<int>(fullContentTokenCount);
    }
    if (!nullToAbsent || summaryTokenCount != null) {
      map['summary_token_count'] = Variable<int>(summaryTokenCount);
    }
    if (!nullToAbsent || fullContentTokenCountMethod != null) {
      map['full_content_token_count_method'] =
          Variable<String>(fullContentTokenCountMethod);
    }
    if (!nullToAbsent || summaryTokenCountMethod != null) {
      map['summary_token_count_method'] =
          Variable<String>(summaryTokenCountMethod);
    }
    map['prefer_summary'] = Variable<bool>(preferSummary);
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
      fullContentTokenCount: fullContentTokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(fullContentTokenCount),
      summaryTokenCount: summaryTokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryTokenCount),
      fullContentTokenCountMethod:
          fullContentTokenCountMethod == null && nullToAbsent
              ? const Value.absent()
              : Value(fullContentTokenCountMethod),
      summaryTokenCountMethod: summaryTokenCountMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryTokenCountMethod),
      preferSummary: Value(preferSummary),
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
      fullContentTokenCount:
          serializer.fromJson<int?>(json['fullContentTokenCount']),
      summaryTokenCount: serializer.fromJson<int?>(json['summaryTokenCount']),
      fullContentTokenCountMethod:
          serializer.fromJson<String?>(json['fullContentTokenCountMethod']),
      summaryTokenCountMethod:
          serializer.fromJson<String?>(json['summaryTokenCountMethod']),
      preferSummary: serializer.fromJson<bool>(json['preferSummary']),
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
      'fullContentTokenCount': serializer.toJson<int?>(fullContentTokenCount),
      'summaryTokenCount': serializer.toJson<int?>(summaryTokenCount),
      'fullContentTokenCountMethod':
          serializer.toJson<String?>(fullContentTokenCountMethod),
      'summaryTokenCountMethod':
          serializer.toJson<String?>(summaryTokenCountMethod),
      'preferSummary': serializer.toJson<bool>(preferSummary),
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
          Value<int?> fullContentTokenCount = const Value.absent(),
          Value<int?> summaryTokenCount = const Value.absent(),
          Value<String?> fullContentTokenCountMethod = const Value.absent(),
          Value<String?> summaryTokenCountMethod = const Value.absent(),
          bool? preferSummary,
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
        fullContentTokenCount: fullContentTokenCount.present
            ? fullContentTokenCount.value
            : this.fullContentTokenCount,
        summaryTokenCount: summaryTokenCount.present
            ? summaryTokenCount.value
            : this.summaryTokenCount,
        fullContentTokenCountMethod: fullContentTokenCountMethod.present
            ? fullContentTokenCountMethod.value
            : this.fullContentTokenCountMethod,
        summaryTokenCountMethod: summaryTokenCountMethod.present
            ? summaryTokenCountMethod.value
            : this.summaryTokenCountMethod,
        preferSummary: preferSummary ?? this.preferSummary,
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
      fullContentTokenCount: data.fullContentTokenCount.present
          ? data.fullContentTokenCount.value
          : this.fullContentTokenCount,
      summaryTokenCount: data.summaryTokenCount.present
          ? data.summaryTokenCount.value
          : this.summaryTokenCount,
      fullContentTokenCountMethod: data.fullContentTokenCountMethod.present
          ? data.fullContentTokenCountMethod.value
          : this.fullContentTokenCountMethod,
      summaryTokenCountMethod: data.summaryTokenCountMethod.present
          ? data.summaryTokenCountMethod.value
          : this.summaryTokenCountMethod,
      preferSummary: data.preferSummary.present
          ? data.preferSummary.value
          : this.preferSummary,
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
          ..write('fullContentTokenCount: $fullContentTokenCount, ')
          ..write('summaryTokenCount: $summaryTokenCount, ')
          ..write('fullContentTokenCountMethod: $fullContentTokenCountMethod, ')
          ..write('summaryTokenCountMethod: $summaryTokenCountMethod, ')
          ..write('preferSummary: $preferSummary, ')
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
      fullContentTokenCount,
      summaryTokenCount,
      fullContentTokenCountMethod,
      summaryTokenCountMethod,
      preferSummary,
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
          other.fullContentTokenCount == this.fullContentTokenCount &&
          other.summaryTokenCount == this.summaryTokenCount &&
          other.fullContentTokenCountMethod ==
              this.fullContentTokenCountMethod &&
          other.summaryTokenCountMethod == this.summaryTokenCountMethod &&
          other.preferSummary == this.preferSummary &&
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
  final Value<int?> fullContentTokenCount;
  final Value<int?> summaryTokenCount;
  final Value<String?> fullContentTokenCountMethod;
  final Value<String?> summaryTokenCountMethod;
  final Value<bool> preferSummary;
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
    this.fullContentTokenCount = const Value.absent(),
    this.summaryTokenCount = const Value.absent(),
    this.fullContentTokenCountMethod = const Value.absent(),
    this.summaryTokenCountMethod = const Value.absent(),
    this.preferSummary = const Value.absent(),
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
    this.fullContentTokenCount = const Value.absent(),
    this.summaryTokenCount = const Value.absent(),
    this.fullContentTokenCountMethod = const Value.absent(),
    this.summaryTokenCountMethod = const Value.absent(),
    this.preferSummary = const Value.absent(),
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
    Expression<int>? fullContentTokenCount,
    Expression<int>? summaryTokenCount,
    Expression<String>? fullContentTokenCountMethod,
    Expression<String>? summaryTokenCountMethod,
    Expression<bool>? preferSummary,
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
      if (fullContentTokenCount != null)
        'full_content_token_count': fullContentTokenCount,
      if (summaryTokenCount != null) 'summary_token_count': summaryTokenCount,
      if (fullContentTokenCountMethod != null)
        'full_content_token_count_method': fullContentTokenCountMethod,
      if (summaryTokenCountMethod != null)
        'summary_token_count_method': summaryTokenCountMethod,
      if (preferSummary != null) 'prefer_summary': preferSummary,
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
      Value<int?>? fullContentTokenCount,
      Value<int?>? summaryTokenCount,
      Value<String?>? fullContentTokenCountMethod,
      Value<String?>? summaryTokenCountMethod,
      Value<bool>? preferSummary,
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
      fullContentTokenCount:
          fullContentTokenCount ?? this.fullContentTokenCount,
      summaryTokenCount: summaryTokenCount ?? this.summaryTokenCount,
      fullContentTokenCountMethod:
          fullContentTokenCountMethod ?? this.fullContentTokenCountMethod,
      summaryTokenCountMethod:
          summaryTokenCountMethod ?? this.summaryTokenCountMethod,
      preferSummary: preferSummary ?? this.preferSummary,
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
    if (fullContentTokenCount.present) {
      map['full_content_token_count'] =
          Variable<int>(fullContentTokenCount.value);
    }
    if (summaryTokenCount.present) {
      map['summary_token_count'] = Variable<int>(summaryTokenCount.value);
    }
    if (fullContentTokenCountMethod.present) {
      map['full_content_token_count_method'] =
          Variable<String>(fullContentTokenCountMethod.value);
    }
    if (summaryTokenCountMethod.present) {
      map['summary_token_count_method'] =
          Variable<String>(summaryTokenCountMethod.value);
    }
    if (preferSummary.present) {
      map['prefer_summary'] = Variable<bool>(preferSummary.value);
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
          ..write('fullContentTokenCount: $fullContentTokenCount, ')
          ..write('summaryTokenCount: $summaryTokenCount, ')
          ..write('fullContentTokenCountMethod: $fullContentTokenCountMethod, ')
          ..write('summaryTokenCountMethod: $summaryTokenCountMethod, ')
          ..write('preferSummary: $preferSummary, ')
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
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
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
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
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
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        title,
        content,
        summary,
        notes,
        tags,
        createdAt,
        updatedAt,
        lastUsedAt
      ];
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
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
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
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
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
  /// Primary key and unique identifier for the snippet
  final int id;

  /// Optional reference to a project
  final int? projectId;

  /// User-defined title of the snippet
  /// This can be empty but defaults to an empty string
  final String title;

  /// Main content of the snippet (e.g., code, text, etc.)
  /// This can be empty but defaults to an empty string
  final String content;

  /// Optional AI-generated or user-provided summary of the content
  /// This can be null if no summary is available
  final String? summary;

  /// Notes for the snippet
  /// This can be null if no notes are available
  final String? notes;

  /// "|"-separated list of tags for categorizing the snippet
  /// This can be null if no tags are available
  final String? tags;

  /// When the snippet was first created
  final DateTime createdAt;

  /// When the snippet was last modified
  /// Can be null if never modified after creation
  final DateTime? updatedAt;

  /// When the snippet was last accessed/used
  /// Can be null if never used after creation
  final DateTime? lastUsedAt;
  const Snippet(
      {required this.id,
      this.projectId,
      required this.title,
      required this.content,
      this.summary,
      this.notes,
      this.tags,
      required this.createdAt,
      this.updatedAt,
      this.lastUsedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
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
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      title: Value(title),
      content: Value(content),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
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
      projectId: serializer.fromJson<int?>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      summary: serializer.fromJson<String?>(json['summary']),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String?>(json['tags']),
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
      'projectId': serializer.toJson<int?>(projectId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'summary': serializer.toJson<String?>(summary),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
    };
  }

  Snippet copyWith(
          {int? id,
          Value<int?> projectId = const Value.absent(),
          String? title,
          String? content,
          Value<String?> summary = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> tags = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> lastUsedAt = const Value.absent()}) =>
      Snippet(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        title: title ?? this.title,
        content: content ?? this.content,
        summary: summary.present ? summary.value : this.summary,
        notes: notes.present ? notes.value : this.notes,
        tags: tags.present ? tags.value : this.tags,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
      );
  Snippet copyWithCompanion(SnippetsCompanion data) {
    return Snippet(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      summary: data.summary.present ? data.summary.value : this.summary,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
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
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('summary: $summary, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, title, content, summary, notes,
      tags, createdAt, updatedAt, lastUsedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snippet &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.content == this.content &&
          other.summary == this.summary &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastUsedAt == this.lastUsedAt);
}

class SnippetsCompanion extends UpdateCompanion<Snippet> {
  final Value<int> id;
  final Value<int?> projectId;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> summary;
  final Value<String?> notes;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> lastUsedAt;
  const SnippetsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.summary = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  });
  SnippetsCompanion.insert({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.summary = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  });
  static Insertable<Snippet> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? summary,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastUsedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (summary != null) 'summary': summary,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
    });
  }

  SnippetsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? projectId,
      Value<String>? title,
      Value<String>? content,
      Value<String?>? summary,
      Value<String?>? notes,
      Value<String?>? tags,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? lastUsedAt}) {
    return SnippetsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
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
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
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
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('summary: $summary, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
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
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $PromptsTable prompts = $PromptsTable(this);
  late final $PromptBlocksTable promptBlocks = $PromptBlocksTable(this);
  late final $SnippetsTable snippets = $SnippetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [projects, prompts, promptBlocks, snippets];
}

typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> notes,
  Value<String?> emoji,
  Value<int?> color,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> notes,
  Value<String?> emoji,
  Value<int?> color,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$Database, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PromptsTable, List<Prompt>> _promptsRefsTable(
          _$Database db) =>
      MultiTypedResultKey.fromTable(db.prompts,
          aliasName:
              $_aliasNameGenerator(db.projects.id, db.prompts.projectId));

  $$PromptsTableProcessedTableManager get promptsRefs {
    final manager = $$PromptsTableTableManager($_db, $_db.prompts)
        .filter((f) => f.projectId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_promptsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SnippetsTable, List<Snippet>> _snippetsRefsTable(
          _$Database db) =>
      MultiTypedResultKey.fromTable(db.snippets,
          aliasName:
              $_aliasNameGenerator(db.projects.id, db.snippets.projectId));

  $$SnippetsTableProcessedTableManager get snippetsRefs {
    final manager = $$SnippetsTableTableManager($_db, $_db.snippets)
        .filter((f) => f.projectId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_snippetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$Database, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
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

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> promptsRefs(
      Expression<bool> Function($$PromptsTableFilterComposer f) f) {
    final $$PromptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.prompts,
        getReferencedColumn: (t) => t.projectId,
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
    return f(composer);
  }

  Expression<bool> snippetsRefs(
      Expression<bool> Function($$SnippetsTableFilterComposer f) f) {
    final $$SnippetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.snippets,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SnippetsTableFilterComposer(
              $db: $db,
              $table: $db.snippets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$Database, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
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

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$Database, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
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

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> promptsRefs<T extends Object>(
      Expression<T> Function($$PromptsTableAnnotationComposer a) f) {
    final $$PromptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.prompts,
        getReferencedColumn: (t) => t.projectId,
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
    return f(composer);
  }

  Expression<T> snippetsRefs<T extends Object>(
      Expression<T> Function($$SnippetsTableAnnotationComposer a) f) {
    final $$SnippetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.snippets,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SnippetsTableAnnotationComposer(
              $db: $db,
              $table: $db.snippets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$Database,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function({bool promptsRefs, bool snippetsRefs})> {
  $$ProjectsTableTableManager(_$Database db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String?> emoji = const Value.absent(),
            Value<int?> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            title: title,
            notes: notes,
            emoji: emoji,
            color: color,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String?> emoji = const Value.absent(),
            Value<int?> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            title: title,
            notes: notes,
            emoji: emoji,
            color: color,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProjectsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({promptsRefs = false, snippetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (promptsRefs) db.prompts,
                if (snippetsRefs) db.snippets
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (promptsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._promptsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .promptsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (snippetsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._snippetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .snippetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function({bool promptsRefs, bool snippetsRefs})>;
typedef $$PromptsTableCreateCompanionBuilder = PromptsCompanion Function({
  Value<int> id,
  Value<int?> projectId,
  Value<String> title,
  Value<String> notes,
  Value<String?> chatUrl,
  Value<String> tags,
  Value<String?> folderPath,
  Value<String> ignorePatterns,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastOpenedAt,
});
typedef $$PromptsTableUpdateCompanionBuilder = PromptsCompanion Function({
  Value<int> id,
  Value<int?> projectId,
  Value<String> title,
  Value<String> notes,
  Value<String?> chatUrl,
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

  static $ProjectsTable _projectIdTable(_$Database db) => db.projects
      .createAlias($_aliasNameGenerator(db.prompts.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    if ($_item.projectId == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id($_item.projectId!));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

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

  ColumnFilters<String> get chatUrl => $composableBuilder(
      column: $table.chatUrl, builder: (column) => ColumnFilters(column));

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

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

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

  ColumnOrderings<String> get chatUrl => $composableBuilder(
      column: $table.chatUrl, builder: (column) => ColumnOrderings(column));

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

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<String> get chatUrl =>
      $composableBuilder(column: $table.chatUrl, builder: (column) => column);

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

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

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
    PrefetchHooks Function({bool projectId, bool promptBlocksRefs})> {
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
            Value<int?> projectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String?> chatUrl = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> folderPath = const Value.absent(),
            Value<String> ignorePatterns = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastOpenedAt = const Value.absent(),
          }) =>
              PromptsCompanion(
            id: id,
            projectId: projectId,
            title: title,
            notes: notes,
            chatUrl: chatUrl,
            tags: tags,
            folderPath: folderPath,
            ignorePatterns: ignorePatterns,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastOpenedAt: lastOpenedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> projectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String?> chatUrl = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> folderPath = const Value.absent(),
            Value<String> ignorePatterns = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastOpenedAt = const Value.absent(),
          }) =>
              PromptsCompanion.insert(
            id: id,
            projectId: projectId,
            title: title,
            notes: notes,
            chatUrl: chatUrl,
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
          prefetchHooksCallback: (
              {projectId = false, promptBlocksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (promptBlocksRefs) db.promptBlocks],
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
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$PromptsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$PromptsTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
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
    PrefetchHooks Function({bool projectId, bool promptBlocksRefs})>;
typedef $$PromptBlocksTableCreateCompanionBuilder = PromptBlocksCompanion
    Function({
  Value<int> id,
  required int promptId,
  Value<double> sortOrder,
  required String blockType,
  Value<String> displayName,
  Value<int?> fullContentTokenCount,
  Value<int?> summaryTokenCount,
  Value<String?> fullContentTokenCountMethod,
  Value<String?> summaryTokenCountMethod,
  Value<bool> preferSummary,
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
  Value<int?> fullContentTokenCount,
  Value<int?> summaryTokenCount,
  Value<String?> fullContentTokenCountMethod,
  Value<String?> summaryTokenCountMethod,
  Value<bool> preferSummary,
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

  ColumnFilters<int> get fullContentTokenCount => $composableBuilder(
      column: $table.fullContentTokenCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get summaryTokenCount => $composableBuilder(
      column: $table.summaryTokenCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullContentTokenCountMethod => $composableBuilder(
      column: $table.fullContentTokenCountMethod,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summaryTokenCountMethod => $composableBuilder(
      column: $table.summaryTokenCountMethod,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get preferSummary => $composableBuilder(
      column: $table.preferSummary, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<int> get fullContentTokenCount => $composableBuilder(
      column: $table.fullContentTokenCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get summaryTokenCount => $composableBuilder(
      column: $table.summaryTokenCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullContentTokenCountMethod => $composableBuilder(
      column: $table.fullContentTokenCountMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summaryTokenCountMethod => $composableBuilder(
      column: $table.summaryTokenCountMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get preferSummary => $composableBuilder(
      column: $table.preferSummary,
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

  GeneratedColumn<int> get fullContentTokenCount => $composableBuilder(
      column: $table.fullContentTokenCount, builder: (column) => column);

  GeneratedColumn<int> get summaryTokenCount => $composableBuilder(
      column: $table.summaryTokenCount, builder: (column) => column);

  GeneratedColumn<String> get fullContentTokenCountMethod => $composableBuilder(
      column: $table.fullContentTokenCountMethod, builder: (column) => column);

  GeneratedColumn<String> get summaryTokenCountMethod => $composableBuilder(
      column: $table.summaryTokenCountMethod, builder: (column) => column);

  GeneratedColumn<bool> get preferSummary => $composableBuilder(
      column: $table.preferSummary, builder: (column) => column);

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
    PrefetchHooks Function({bool promptId})> {
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
            Value<int?> fullContentTokenCount = const Value.absent(),
            Value<int?> summaryTokenCount = const Value.absent(),
            Value<String?> fullContentTokenCountMethod = const Value.absent(),
            Value<String?> summaryTokenCountMethod = const Value.absent(),
            Value<bool> preferSummary = const Value.absent(),
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
            fullContentTokenCount: fullContentTokenCount,
            summaryTokenCount: summaryTokenCount,
            fullContentTokenCountMethod: fullContentTokenCountMethod,
            summaryTokenCountMethod: summaryTokenCountMethod,
            preferSummary: preferSummary,
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
            Value<int?> fullContentTokenCount = const Value.absent(),
            Value<int?> summaryTokenCount = const Value.absent(),
            Value<String?> fullContentTokenCountMethod = const Value.absent(),
            Value<String?> summaryTokenCountMethod = const Value.absent(),
            Value<bool> preferSummary = const Value.absent(),
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
            fullContentTokenCount: fullContentTokenCount,
            summaryTokenCount: summaryTokenCount,
            fullContentTokenCountMethod: fullContentTokenCountMethod,
            summaryTokenCountMethod: summaryTokenCountMethod,
            preferSummary: preferSummary,
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
          prefetchHooksCallback: ({promptId = false}) {
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
                return [];
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
    PrefetchHooks Function({bool promptId})>;
typedef $$SnippetsTableCreateCompanionBuilder = SnippetsCompanion Function({
  Value<int> id,
  Value<int?> projectId,
  Value<String> title,
  Value<String> content,
  Value<String?> summary,
  Value<String?> notes,
  Value<String?> tags,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastUsedAt,
});
typedef $$SnippetsTableUpdateCompanionBuilder = SnippetsCompanion Function({
  Value<int> id,
  Value<int?> projectId,
  Value<String> title,
  Value<String> content,
  Value<String?> summary,
  Value<String?> notes,
  Value<String?> tags,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastUsedAt,
});

final class $$SnippetsTableReferences
    extends BaseReferences<_$Database, $SnippetsTable, Snippet> {
  $$SnippetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$Database db) => db.projects
      .createAlias($_aliasNameGenerator(db.snippets.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    if ($_item.projectId == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id($_item.projectId!));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

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

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (Snippet, $$SnippetsTableReferences),
    Snippet,
    PrefetchHooks Function({bool projectId})> {
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
            Value<int?> projectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
          }) =>
              SnippetsCompanion(
            id: id,
            projectId: projectId,
            title: title,
            content: content,
            summary: summary,
            notes: notes,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastUsedAt: lastUsedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> projectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
          }) =>
              SnippetsCompanion.insert(
            id: id,
            projectId: projectId,
            title: title,
            content: content,
            summary: summary,
            notes: notes,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastUsedAt: lastUsedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SnippetsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
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
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$SnippetsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$SnippetsTableReferences._projectIdTable(db).id,
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

typedef $$SnippetsTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $SnippetsTable,
    Snippet,
    $$SnippetsTableFilterComposer,
    $$SnippetsTableOrderingComposer,
    $$SnippetsTableAnnotationComposer,
    $$SnippetsTableCreateCompanionBuilder,
    $$SnippetsTableUpdateCompanionBuilder,
    (Snippet, $$SnippetsTableReferences),
    Snippet,
    PrefetchHooks Function({bool projectId})>;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$PromptsTableTableManager get prompts =>
      $$PromptsTableTableManager(_db, _db.prompts);
  $$PromptBlocksTableTableManager get promptBlocks =>
      $$PromptBlocksTableTableManager(_db, _db.promptBlocks);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db, _db.snippets);
}
