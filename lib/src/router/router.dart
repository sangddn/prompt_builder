import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: ShellRoute.page,
          children: [
            AutoRoute(
              path: 'library',
              page: LibraryRoute.page,
              children: [
                AutoRoute(path: 'prompt', page: PromptRoute.page),
              ],
            ),
            AutoRoute(path: 'text-prompts', page: TextPromptsRoute.page),
            AutoRoute(path: 'settings', page: SettingsRoute.page),
            AutoRoute(path: 'resources', page: ResourcesRoute.page),
          ],
        ),
      ];
}
