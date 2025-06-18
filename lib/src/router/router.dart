import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    DefaultRoute(
      initial: true,
      page: AppShellRoute.page,
      children: [
        DefaultRoute(
          initial: true,
          page: MainTabsRoute.page,
          children: [
            DefaultRoute(path: 'library', page: LibraryRoute.page),
            DefaultRoute(path: 'projects', page: ProjectsRoute.page),
            DefaultRoute(path: 'snippets', page: SnippetsRoute.page),
            DefaultRoute(path: 'settings', page: SettingsRoute.page),
            DefaultRoute(path: 'resources', page: ResourcesRoute.page),
          ],
        ),
        DefaultRoute(path: 'prompt/:id', page: PromptRoute.page),
        DefaultRoute(path: 'project/:id', page: ProjectRoute.page),
        DefaultRoute(path: 'snippet/:id', page: SnippetRoute.page),
      ],
    ),
  ];
}

class DefaultRoute extends CustomRoute<void> {
  DefaultRoute({super.path, super.initial, required super.page, super.children})
    : super(
        transitionsBuilder: TransitionsBuilders.fadeIn,
        durationInMilliseconds: 50,
      );
}

extension RoutingExtension on BuildContext {
  void _ensureMainTabsRoute() {
    if (router.topRoute.parent?.name != 'MainTabsRoute') {
      router.popUntil(scoped: false, (route) {
        return route.data?.name == 'MainTabsRoute';
      });
    }
  }

  void _ensureMainTabsOrProjectRoute() {
    if (router.topRoute.parent?.name != 'MainTabsRoute' &&
        router.topRoute.parent?.name != 'ProjectRoute') {
      router.popUntil(scoped: false, (route) {
        return route.data?.name == 'MainTabsRoute' ||
            route.data?.name == 'ProjectRoute';
      });
    }
  }

  Future<void> pushPromptRoute({required int id}) {
    _ensureMainTabsOrProjectRoute();
    return pushRoute(PromptRoute(id: id));
  }

  Future<void> pushProjectRoute({required int id}) {
    _ensureMainTabsRoute();
    return pushRoute(ProjectRoute(id: id));
  }

  Future<void> pushSnippetRoute({required int id}) {
    _ensureMainTabsOrProjectRoute();
    return pushRoute(SnippetRoute(id: id));
  }
}
