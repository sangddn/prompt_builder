import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:super_clipboard/super_clipboard.dart';

bool canBeRepresentedAsText(String filePath) {
  // If is code or markdown, return true
  if (isCodeFile(filePath) || isMarkdownFile(filePath)) return true;

  final mimeType = lookupMimeType(filePath);
  if (mimeType == null) return false;

  // Text-based MIME types
  if (mimeType.startsWith('text/')) return true;

  // Common text-based application MIME types
  const textBasedApplicationTypes = {
    'application/json',
    'application/xml',
    'application/x-yaml',
    'application/yaml',
    'application/toml',
    'application/x-toml',
    'application/javascript',
    'application/ecmascript',
    'application/x-javascript',
    'application/typescript',
    'application/x-typescript',
    'application/x-httpd-php',
    'application/x-sh',
    'application/x-bash',
    'application/x-ruby',
    'application/x-python',
    'application/graphql',
    'application/ld+json', // JSON-LD
    'application/x-www-form-urlencoded',
    'application/x-sql',
    'application/csv',
    'application/x-properties',
    'application/x-tex',
    'application/rtf',
    'application/x-perl',
  };

  return textBasedApplicationTypes.contains(mimeType);
}

bool isAudioFile(String filePath) {
  final mimeType = lookupMimeType(filePath);
  return mimeType != null && mimeType.startsWith('audio/');
}

bool isImageFile(String filePath) {
  final mimeType = lookupMimeType(filePath);
  return mimeType != null && mimeType.startsWith('image/');
}

bool isPdfFile(String filePath) {
  final mimeType = lookupMimeType(filePath);
  return mimeType != null && mimeType.startsWith('application/pdf');
}

bool isVideoFile(String filePath) {
  final mimeType = lookupMimeType(filePath);
  return mimeType != null && mimeType.startsWith('video/');
}

bool isCodeFile(String filePath) {
  final extension = path.extension(filePath).replaceAll('.', '').toLowerCase();
  return _codeFileExtensions.containsKey(extension);
}

bool isMarkdownFile(String filePath) {
  final extension = path.extension(filePath).replaceAll('.', '').toLowerCase();
  return extension == 'md' || extension == 'markdown';
}

String? getCodeLanguage(String fileExtension) =>
    _codeFileExtensions[fileExtension];

// Map of file extensions to their corresponding language identifiers
const _codeFileExtensions = {
  // Common web languages
  'js': 'javascript',
  'ts': 'typescript',
  'html': 'html',
  'css': 'css',
  'scss': 'scss',
  'less': 'less',
  'json': 'json',
  'xml': 'xml',
  'yaml': 'yaml',
  'yml': 'yaml',
  'graphql': 'graphql',
  'gql': 'graphql',
  'vue': 'vue',

  // Programming languages
  'py': 'python',
  'rb': 'ruby',
  'php': 'php',
  'java': 'java',
  'kt': 'kotlin',
  'scala': 'scala',
  'cs': 'cs',
  'fs': 'fsharp',
  'go': 'go',
  'rs': 'rust',
  'swift': 'swift',
  'dart': 'dart',
  'r': 'r',
  'lua': 'lua',
  'pl': 'perl',
  'elm': 'elm',
  'erl': 'erlang',
  'ex': 'elixir',
  'exs': 'elixir',
  'hs': 'haskell',
  'ml': 'ocaml',
  'clj': 'clojure',
  'coffee': 'coffeescript',
  // 'ts': 'typescript',
  'jsx': 'javascript',
  'tsx': 'typescript',

  // Shell/config languages
  'sh': 'bash',
  'bash': 'bash',
  'zsh': 'bash',
  'fish': 'bash',
  'ini': 'ini',
  'conf': 'ini',
  'toml': 'ini',
  'dockerfile': 'dockerfile',

  // Systems languages
  'c': 'c',
  'h': 'c',
  'cpp': 'cpp',
  'hpp': 'cpp',
  'cc': 'cpp',
  'hh': 'cpp',
  'asm': 'x86asm',

  // Database languages
  'sql': 'sql',
  'pgsql': 'pgsql',
  'mysql': 'sql',

  // Markup/template languages
  'md': 'markdown',
  'markdown': 'markdown',
  'tex': 'tex',
  'latex': 'tex',
  'haml': 'haml',
  'slim': 'ruby',
  'jade': 'javascript',
  'pug': 'javascript',
  'liquid': 'ruby',
  'erb': 'erb',
  'twig': 'twig',

  // Build/config files
  'gradle': 'gradle',
  'maven': 'xml',
  'pom': 'xml',
  'cmake': 'cmake',
  'make': 'makefile',
  'mk': 'makefile',

  // Other
  'sol': 'solidity',
  'proto': 'protobuf',
  'gn': 'gn',
};

DataFormat? getDataFormat(String filePath) {
  final extension = filePath.split('.').last.toLowerCase();

  return switch (extension) {
    'txt' => Formats.plainTextFile,
    'html' || 'htm' => Formats.htmlFile,
    'jpg' || 'jpeg' => Formats.jpeg,
    'png' => Formats.png,
    'svg' => Formats.svg,
    'gif' => Formats.gif,
    'webp' => Formats.webp,
    'tiff' || 'tif' => Formats.tiff,
    'bmp' => Formats.bmp,
    'ico' => Formats.ico,
    'heic' => Formats.heic,
    'heif' => Formats.heif,
    'mp4' => Formats.mp4,
    'mov' => Formats.mov,
    'm4v' => Formats.m4v,
    'avi' => Formats.avi,
    'mpeg' || 'mpg' => Formats.mpeg,
    'webm' => Formats.webm,
    'ogg' => Formats.ogg,
    'wmv' => Formats.wmv,
    'flv' => Formats.flv,
    'mkv' => Formats.mkv,
    'ts' => Formats.ts,
    'mp3' => Formats.mp3,
    'oga' => Formats.oga,
    'aac' => Formats.aac,
    'wav' => Formats.wav,
    'pdf' => Formats.pdf,
    'doc' || 'docx' => Formats.doc,
    'csv' => Formats.csv,
    'xls' || 'xlsx' => Formats.xls,
    'ppt' || 'pptx' => Formats.ppt,
    'rtf' => Formats.rtf,
    'json' => Formats.json,
    'zip' => Formats.zip,
    'tar' => Formats.tar,
    'gz' || 'gzip' => Formats.gzip,
    'bz2' => Formats.bzip2,
    'xz' => Formats.xz,
    'rar' => Formats.rar,
    'jar' => Formats.jar,
    '7z' => Formats.sevenZip,
    'dmg' => Formats.dmg,
    'iso' => Formats.iso,
    'deb' => Formats.deb,
    'rpm' => Formats.rpm,
    'apk' => Formats.apk,
    'exe' => Formats.exe,
    'msi' => Formats.msi,
    'dll' => Formats.dll,
    _ => null,
  };
}
