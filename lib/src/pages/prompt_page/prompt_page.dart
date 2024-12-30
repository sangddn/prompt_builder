import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../services/services.dart';
import '../library_page/library_observer.dart';

part 'states/pp_providers.dart';
part 'states/pp_prompt_extensions.dart';
part 'states/pp_llm_scope.dart';
part 'states/pp_block_scope.dart';
part 'states/pp_block_content_scope.dart';
part 'states/pp_file_tree_scope.dart';
part 'states/pp_keyboard_listener.dart';

part 'components/pp_app_bar.dart';
part 'components/pp_drop_region.dart';
part 'components/pp_main_body.dart';
part 'components/pp_folder_tree.dart';
part 'components/pp_search_section.dart';
part 'components/pp_prompt_content.dart';
part 'components/pp_right_sidebar.dart';
part 'components/pp_unsupported_block_section.dart';
part 'components/pp_copy_section.dart';
part 'components/pp_file_search_dialog.dart';

@RoutePage()
class PromptPage extends StatelessWidget {
  const PromptPage({
    this.database,
    required this.id,
    super.key,
  });

  final Database? database;
  final int id;

  @override
  Widget build(BuildContext context) {
    return _PPProviders(
      db: database ?? Database(),
      id: id,
      child: const Scaffold(
        body: _PPDropRegion(
          child: Column(
            children: [
              _PPAppBar(),
              Expanded(child: _PPMainBody()),
            ],
          ),
        ),
      ),
    );
  }
}
