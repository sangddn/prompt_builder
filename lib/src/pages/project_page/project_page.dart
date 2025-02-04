import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../app.dart';
import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../router/router.dart';

part 'states/prp_providers.dart';

part 'components/prp_app_bar.dart';
part 'components/prp_snippet_grid.dart';
part 'components/prp_prompt_grid.dart';

@RoutePage()
class ProjectPage extends StatelessWidget {
  const ProjectPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) => _PRPProviders(
        id: id,
        child: const Scaffold(
          body: ConstrainedCustomScrollView(
            maxCrossAxisExtent: 1000.0,
            slivers: [
              ConstrainedSliver(
                sliver: SliverSafeArea(
                  bottom: false,
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 56.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: MaybeBackButton(),
                      ),
                    ),
                  ),
                ),
              ),
              SliverGap(24.0),
              _PRPAppBar(),
              SliverToBoxAdapter(child: Divider(height: 64.0, thickness: .5)),
              _PRPSnippetGridTitle(),
              SliverGap(16.0),
              _PRPSnippetGrid(),
              SliverGap(64.0),
              _PRPPromptGridTitle(),
              SliverGap(16.0),
              _PRPPromptGrid(),
            ],
          ),
        ),
      );
}
