import 'package:auto_route/auto_route.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../app.dart';
import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';

part 'components/snpp_app_bar.dart';
part 'components/snpp_content.dart';
part 'components/snpp_right_sidebar.dart';
part 'states/snpp_providers.dart';

@RoutePage()
class SnippetPage extends StatelessWidget {
  const SnippetPage({this.onSaved, required this.id, super.key});

  final VoidCallback? onSaved;
  final int id;

  @override
  Widget build(BuildContext context) {
    return _SnippetProviders(
      id: id,
      onSaved: onSaved,
      child: const Scaffold(
        body: Column(
          children: [
            _SNPPAppBar(),
            Expanded(
              child: ShadResizablePanelGroup(
                resetOnDoubleTap: true,
                dividerColor: Colors.transparent,
                dividerSize: 16.0,
                children: [
                  ShadResizablePanel(
                    id: 'content',
                    defaultSize: .8,
                    minSize: .4,
                    maxSize: .8,
                    child: _SNPPContent(),
                  ),
                  ShadResizablePanel(
                    id: 'sidebar',
                    defaultSize: .2,
                    minSize: .2,
                    maxSize: .6,
                    child: _SNPPRightSidebar(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
