import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../app.dart';
import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import 'library_observer.dart';

part 'states/lp_providers.dart';

part 'components/lp_app_bar.dart';
part 'components/lp_prompt_list.dart';
part 'components/lp_search_bar.dart';
part 'components/lp_filter_bar.dart';

@RoutePage()
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LPProviders(
      child: Scaffold(
        body: ConstrainedCustomScrollView(
          maxCrossAxisExtent: 1400.0,
          slivers: [
            _LPAppBar(),
            SliverPadding(padding: k16HPadding, sliver: _LPSearchBar()),
            SliverGap(16.0),
            _LPFilterBar(),
            SliverGap(16.0),
            _LPPromptList(),
            SliverGap(128.0),
          ],
        ),
      ),
    );
  }
}
