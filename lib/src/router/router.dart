import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        DefaultRoute(
          initial: true,
          page: ShellRoute.page,
          children: [
            DefaultRoute(
              path: 'library',
              page: LibraryShellRoute.page,
              children: [
                DefaultRoute(
                  initial: true,
                  page: LibraryRoute.page,
                ),
                DefaultRoute(
                  path: 'prompt',
                  page: PromptRoute.page,
                ),
              ],
            ),
            DefaultRoute(path: 'snippets', page: SnippetsRoute.page),
            DefaultRoute(path: 'settings', page: SettingsRoute.page),
            DefaultRoute(path: 'resources', page: ResourcesRoute.page),
          ],
        ),
      ];
}

@RoutePage()
class LibraryShellPage extends AutoRouter {
  const LibraryShellPage({super.key});
}

class DefaultRoute extends CustomRoute<void> {
  DefaultRoute({
    super.path,
    super.initial,
    required super.page,
    super.children,
  }) : super(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 50,
        );
}
