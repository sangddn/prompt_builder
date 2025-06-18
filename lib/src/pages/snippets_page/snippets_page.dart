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

part 'components/snp_add_snippet_button.dart';
part 'components/snp_app_bar.dart';
part 'components/snp_filter_bar.dart';
part 'components/snp_search_bar.dart';
part 'components/snp_snippet_list.dart';
part 'states/snp_providers.dart';

@RoutePage()
class SnippetsPage extends StatelessWidget {
  const SnippetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SNPProviders(
      child: ShadContextMenuRegion(
        items: [
          Builder(
            builder: (context) {
              return ShadContextMenuItem(
                onPressed:
                    () => context.read<SnippetListController>().refresh(),
                trailing: const Icon(LucideIcons.refreshCcw, size: 16.0),
                child: const Text('Refresh'),
              );
            },
          ),
        ],
        child: const Scaffold(
          body: ConstrainedCustomScrollView(
            slivers: [
              _SNPAppBar(),
              SliverPadding(padding: k16HPadding, sliver: _SNPSearchBar()),
              SliverGap(16.0),
              _SNPFilterBar(),
              SliverGap(16.0),
              _SNPSnippetList(),
              SliverGap(128.0),
            ],
          ),
        ),
      ),
    );
  }
}
