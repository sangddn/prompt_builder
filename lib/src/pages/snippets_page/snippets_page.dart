import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';

part 'states/snp_providers.dart';
part 'states/snippets_controller.dart';

part 'components/snp_app_bar.dart';
part 'components/snp_add_snippet_button.dart';
part 'components/snp_snippet_list.dart';
part 'components/snp_search_bar.dart';

@RoutePage()
class SnippetsPage extends StatelessWidget {
  const SnippetsPage({this.db, super.key});

  final Database? db;

  @override
  Widget build(BuildContext context) {
    return _SNPProviders(
      db: db ?? Database(),
      child: const Scaffold(
        body: ConstrainedCustomScrollView(
          slivers: [
            _SNPAppBar(),
            SliverPadding(padding: k16HPadding, sliver: _SNPSearchBar()),
            SliverGap(16.0),
            _SNPSnippetList(),
            SliverGap(64.0),
          ],
        ),
      ),
    );
  }
}
