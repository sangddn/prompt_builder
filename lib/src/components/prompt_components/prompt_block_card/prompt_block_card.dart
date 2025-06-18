import 'dart:async';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../app.dart';
import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../../pages/block_content_viewer/block_content_viewer.dart';
import '../../../services/services.dart';
import '../../components.dart';

part 'block_router_widget.dart';
part 'block_display_name.dart';
part 'block_token_count.dart';
part 'block_context_menu.dart';
part 'block_actions.dart';
part 'text_block.dart';
part 'image_block.dart';
part 'audio_video_block.dart';
part 'local_file_block.dart';
part 'web_block.dart';
part 'unsupported_block.dart';

part 'summary_explanation.dart';
part 'block_utils.dart';

class PromptBlockCard extends MultiProviderWidget {
  const PromptBlockCard({
    this.padding = EdgeInsets.zero,
    this.prompt,
    this.onMovedUp,
    this.onMovedDown,
    required this.database,
    required this.block,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Prompt? prompt;
  final VoidCallback? onMovedUp;
  final VoidCallback? onMovedDown;
  final Database database;
  final PromptBlock block;

  @override
  List<SingleChildWidget> get providers => [
    Provider<Prompt?>.value(value: prompt),
    Provider<Database>.value(value: database),
    Provider<PromptBlock>.value(value: block),
    ValueProvider<ValueNotifier<BlockWidgetState>>(
      create: (_) => ValueNotifier(BlockWidgetState.collapsed),
    ),
    ValueProvider<ValueNotifier<_BlockHoverState>>(
      create: (_) => ValueNotifier(_BlockHoverState.none),
    ),
    Provider<(VoidCallback?, VoidCallback?)>.value(
      value: (onMovedUp, onMovedDown),
    ),
  ];

  @override
  Widget buildChild(BuildContext context) {
    return _BlockContextMenu(
      child: MouseRegion(
        onEnter: (_) => context.hoverNotifier.value = _BlockHoverState.hover,
        onExit: (_) => context.hoverNotifier.value = _BlockHoverState.none,
        child: Padding(
          padding: padding,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _BlockDisplayName()),
                  Gap(8.0),
                  _BlockInfoBar(),
                ],
              ),
              Gap(8.0),
              _BlockContentRouter(),
              Row(children: [_TokenCount(), Spacer(), _BlockToolBar()]),
            ],
          ),
        ),
      ),
    );
  }
}
