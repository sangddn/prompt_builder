import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../app.dart';
import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../router/router.gr.dart';

part 'states/prj_providers.dart';
part 'states/projects_controller.dart';

part 'components/prj_app_bar.dart';
part 'components/prj_add_project_button.dart';
part 'components/prj_project_list.dart';
part 'components/prj_search_bar.dart';

@RoutePage()
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PRJProviders(
      db: context.read<Database>(),
      child: ShadContextMenuRegion(
        items: [
          Builder(
            builder: (context) {
              return ShadContextMenuItem(
                onPressed: () => context.controller._refresh(),
                trailing: const ShadImage.square(
                  LucideIcons.refreshCcw,
                  size: 16.0,
                ),
                child: const Text('Refresh'),
              );
            },
          ),
        ],
        child: const Scaffold(
          body: ConstrainedCustomScrollView(
            slivers: [
              _PRJAppBar(),
              SliverPadding(padding: k16HPadding, sliver: _PRJSearchBar()),
              SliverGap(16.0),
              _PRJProjectList(),
              SliverGap(128.0),
            ],
          ),
        ),
      ),
    );
  }
}
