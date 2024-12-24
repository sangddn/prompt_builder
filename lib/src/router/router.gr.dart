// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:prompt_builder/src/pages/library_page/library_page.dart' as _i1;
import 'package:prompt_builder/src/pages/resources_page/resources_page.dart'
    as _i2;
import 'package:prompt_builder/src/pages/settings_page/settings_page.dart'
    as _i3;
import 'package:prompt_builder/src/pages/shell_page/shell_page.dart' as _i4;
import 'package:prompt_builder/src/pages/text_prompts_page/text_prompts_page.dart'
    as _i5;

/// generated route for
/// [_i1.LibraryPage]
class LibraryRoute extends _i6.PageRouteInfo<void> {
  const LibraryRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LibraryRoute.name,
          initialChildren: children,
        );

  static const String name = 'LibraryRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.LibraryPage();
    },
  );
}

/// generated route for
/// [_i2.ResourcesPage]
class ResourcesRoute extends _i6.PageRouteInfo<void> {
  const ResourcesRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ResourcesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResourcesRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.ResourcesPage();
    },
  );
}

/// generated route for
/// [_i3.SettingsPage]
class SettingsRoute extends _i6.PageRouteInfo<void> {
  const SettingsRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.SettingsPage();
    },
  );
}

/// generated route for
/// [_i4.ShellPage]
class ShellRoute extends _i6.PageRouteInfo<void> {
  const ShellRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShellRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.ShellPage();
    },
  );
}

/// generated route for
/// [_i5.TextPromptsPage]
class TextPromptsRoute extends _i6.PageRouteInfo<void> {
  const TextPromptsRoute({List<_i6.PageRouteInfo>? children})
      : super(
          TextPromptsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TextPromptsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.TextPromptsPage();
    },
  );
}
