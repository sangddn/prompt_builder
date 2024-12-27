import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

bool canBeRepresentedAsText(String filePath) {
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

bool isVideoFile(String filePath) {
  final mimeType = lookupMimeType(filePath);
  return mimeType != null && mimeType.startsWith('video/');
}

bool isCodeFile(String filePath) {
  final extension = path.extension(filePath).toLowerCase();

  // Map of file extensions to their corresponding language identifiers
  const codeFileExtensions = {
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

  return codeFileExtensions.containsKey(extension);
}
