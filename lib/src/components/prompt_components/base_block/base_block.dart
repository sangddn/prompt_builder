import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../components.dart';

abstract class BaseBlock extends StatelessWidget {
  const BaseBlock({
    required this.database,
    required this.block,
    super.key,
  });

  final Database database;
  final PromptBlock block;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Database>.value(value: database),
        Provider<PromptBlock>.value(value: block),
      ],
      builder: (context, _) => buildBlock(context),
    );
  }

  Widget buildBlock(BuildContext context);
}

class BlockRouterWidget extends StatelessWidget {
  const BlockRouterWidget({
    required this.database,
    required this.block,
    super.key,
  });

  final Database database;
  final PromptBlock block;

  @override
  Widget build(BuildContext context) => switch (block.type) {
        BlockType.text => TextBlock(database: database, block: block),
        BlockType.image => const Text('Image'),
        BlockType.audio => const Text('Audio'),
        BlockType.video => const Text('Video'),
        BlockType.localFile => const Text('Local File'),
        BlockType.youtube => const Text('Youtube'),
        BlockType.webUrl => const Text('Web URL'),
        BlockType.unsupported => const Text('Unsupported'),
      };
}
