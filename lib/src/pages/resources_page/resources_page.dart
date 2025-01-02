import 'package:animated_to/animated_to.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../services/services.dart';

part 'states/rp_providers.dart';

part 'components/rp_submit_button.dart';
part 'components/rp_tag_bar.dart';
part 'components/rp_snippet_list.dart';

@RoutePage()
class ResourcesPage extends StatelessWidget {
  const ResourcesPage({this.db, super.key});

  final Database? db;

  @override
  Widget build(BuildContext context) {
    return _RPProviders(
      db: db ?? Database(),
      child: const Scaffold(
        body: ShadResizablePanelGroup(
          resetOnDoubleTap: true,
          dividerSize: 16.0,
          dividerColor: Colors.transparent,
          children: [
            ShadResizablePanel(
              defaultSize: .3,
              minSize: .2,
              maxSize: .4,
              child: _RPTagBar(),
            ),
            ShadResizablePanel(
              defaultSize: .7,
              minSize: .6,
              maxSize: .8,
              child: _MainContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return ConstrainedCustomScrollView(
      controller: context.read(),
      slivers: const [
        PAppBar(title: Text('Resources')),
        SliverGap(16.0),
        SliverPadding(
          padding: k16HPadding,
          sliver: _RPSnippetList(),
        ),
        SliverGap(64.0),
      ],
    );
  }
}
