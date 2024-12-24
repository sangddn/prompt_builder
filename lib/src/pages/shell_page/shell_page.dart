import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../router/router.gr.dart';

@RoutePage()
class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      homeIndex: 0,
      routes: const [
        LibraryRoute(),
        TextPromptsRoute(),
        SettingsRoute(),
        ResourcesRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Row(
          children: [
            Column(
              children: [
                ShadButton.link(
                  onPressed: () => tabsRouter.setActiveIndex(0),
                  child: const Text('Library'),
                ),
                ShadButton.link(
                  onPressed: () => tabsRouter.setActiveIndex(1),
                  child: const Text('Text Prompts'),
                ),
                ShadButton.link(
                  onPressed: () => tabsRouter.setActiveIndex(2),
                  child: const Text('Settings'),
                ),
                ShadButton.link(
                  onPressed: () => tabsRouter.setActiveIndex(3),
                  child: const Text('Resources'),
                ),
              ],
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
