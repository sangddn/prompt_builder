import 'package:flutter/widgets.dart';

import '../database.dart';

@immutable
class PromptExport {
  const PromptExport({
    required this.title,
    required this.notes,
    required this.tags,
    required this.blocks,
  });

  factory PromptExport.fromPromptAndBlocks(
    Prompt prompt,
    List<PromptBlock> blocks,
  ) {
    return PromptExport(
      title: prompt.title,
      notes: prompt.notes,
      tags: prompt.tags,
      blocks: blocks.map((b) => PromptBlockExport.fromBlock(b)).toList(),
    );
  }

  factory PromptExport.fromJson(Map<String, dynamic> json) {
    return PromptExport(
      title: json['title'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      tags: json['tags'] as String? ?? '',
      blocks:
          (json['blocks'] as List<dynamic>? ?? [])
              .map((e) => PromptBlockExport.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
  final String title;
  final String notes;
  final String tags;
  final List<PromptBlockExport> blocks;

  List<String> get tagList => PromptTagsExtension.tagStringToList(tags);

  Map<String, dynamic> toJson() => {
    'title': title,
    'notes': notes,
    'tags': tags,
    'blocks': blocks.map((b) => b.toJson()).toList(),
  };
}

@immutable
class PromptBlockExport {
  const PromptBlockExport({
    required this.blockType,
    required this.displayName,
    required this.sortOrder,
    this.textContent,
    this.filePath,
    this.url,
    this.transcript,
    this.caption,
    this.summary,
    required this.preferSummary,
  });

  factory PromptBlockExport.fromBlock(PromptBlock block) {
    return PromptBlockExport(
      blockType: block.blockType,
      displayName: block.displayName,
      sortOrder: block.sortOrder,
      textContent: block.textContent,
      filePath: block.filePath,
      url: block.url,
      transcript: block.transcript,
      caption: block.caption,
      summary: block.summary,
      preferSummary: block.preferSummary,
    );
  }

  factory PromptBlockExport.fromJson(Map<String, dynamic> json) {
    return PromptBlockExport(
      blockType: json['blockType'] as String,
      displayName: json['displayName'] as String? ?? '',
      sortOrder: (json['sortOrder'] as num? ?? 0).toDouble(),
      textContent: json['textContent'] as String?,
      filePath: json['filePath'] as String?,
      url: json['url'] as String?,
      transcript: json['transcript'] as String?,
      caption: json['caption'] as String?,
      summary: json['summary'] as String?,
      preferSummary: json['preferSummary'] as bool? ?? false,
    );
  }
  final String blockType;
  final String displayName;
  final double sortOrder;
  final String? textContent;
  final String? filePath;
  final String? url;
  final String? transcript;
  final String? caption;
  final String? summary;
  final bool preferSummary;

  Map<String, dynamic> toJson() => {
    'blockType': blockType,
    'displayName': displayName,
    'sortOrder': sortOrder,
    'textContent': textContent,
    'filePath': filePath,
    'url': url,
    'transcript': transcript,
    'caption': caption,
    'summary': summary,
    'preferSummary': preferSummary,
  };
}
