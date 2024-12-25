import 'package:drift/drift.dart';

/// Represents the different types of content blocks that can be part of a prompt.
enum BlockType {
  /// Plain text content entered by the user
  text,

  /// Local file content like PDFs or documents
  localFile,

  /// YouTube video content with optional transcript
  youtube,

  /// Generic web URL or HTML content
  webUrl,

  /// Audio content from local file or remote URL
  audio,

  /// Video content from local file or remote URL
  video,

  /// Image content from local file or remote URL
  image,

  /// Fallback type for unsupported content formats
  unsupported,
}

/// Database table definition for storing prompt content blocks.
///
/// Each prompt can contain multiple blocks of different types (text, files, media etc.)
/// arranged in a specific order. This table stores all the metadata and content for
/// these blocks.
class PromptBlocks extends Table {
  /// Unique identifier for each block
  IntColumn get id => integer().autoIncrement()();

  /// Reference to the parent prompt this block belongs to
  IntColumn get promptId => integer().customConstraint('REFERENCES prompts(id)')();

  /// Position of this block within the prompt's sequence of blocks
  /// Defaults to 0 if not specified
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// The type of content in this block, stored as a string representation
  /// of the [BlockType] enum
  TextColumn get blockType => text()();

  /// User-facing name/title for this block
  TextColumn get displayName => text().withDefault(const Constant(''))();

  /// Number of tokens in this block's content, used for API limits
  IntColumn get tokenCount => integer().withDefault(const Constant(0))();

  /// Main text content for text-based blocks
  /// Nullable since not all block types contain text
  TextColumn get textContent => text().nullable()();

  /// Local filesystem path or app directory path for file-backed content
  TextColumn get filePath => text().nullable()();

  /// MIME type of the content (e.g. 'application/pdf', 'audio/wav')
  /// Used for proper handling of different file formats
  TextColumn get mimeType => text().nullable()();

  /// Size of the file in bytes, if applicable
  IntColumn get fileSize => integer().nullable()();

  /// URL for web-based content (YouTube videos, web pages, remote media)
  TextColumn get url => text().nullable()();

  /// Transcribed text content for audio/video content
  TextColumn get transcript => text().nullable()();

  /// Caption or alt text for image content
  TextColumn get caption => text().nullable()();

  /// Condensed version of large text content or transcripts
  TextColumn get summary => text().nullable()();

  /// Timestamp when this block was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when this block was last modified
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
