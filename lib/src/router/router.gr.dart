// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:prompt_builder/src/pages/library_page/library_page.dart' as _i1;
import 'package:prompt_builder/src/pages/prompt_page/prompt_page.dart' as _i3;
import 'package:prompt_builder/src/pages/resources_page/resources_page.dart'
    as _i4;
import 'package:prompt_builder/src/pages/settings_page/settings_page.dart'
    as _i5;
import 'package:prompt_builder/src/pages/shell_page/shell_page.dart' as _i6;
import 'package:prompt_builder/src/pages/text_prompts_page/text_prompts_page.dart'
    as _i7;
import 'package:prompt_builder/src/router/router.dart' as _i2;

/// generated route for
/// [_i1.LibraryPage]
class LibraryRoute extends _i8.PageRouteInfo<void> {
  const LibraryRoute({List<_i8.PageRouteInfo>? children})
      : super(
          LibraryRoute.name,
          initialChildren: children,
        );

  static const String name = 'LibraryRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.LibraryPage();
    },
  );
}

/// generated route for
/// [_i2.LibraryShellPage]
class LibraryShellRoute extends _i8.PageRouteInfo<void> {
  const LibraryShellRoute({List<_i8.PageRouteInfo>? children})
      : super(
          LibraryShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'LibraryShellRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.LibraryShellPage();
    },
  );
}

/// generated route for
/// [_i3.PromptPage]
class PromptRoute extends _i8.PageRouteInfo<PromptRouteArgs> {
  PromptRoute({
    required int id,
    _i9.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          PromptRoute.name,
          args: PromptRouteArgs(
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PromptRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PromptRouteArgs>();
      return _i3.PromptPage(
        id: args.id,
        key: args.key,
      );
    },
  );
}

class PromptRouteArgs {
  const PromptRouteArgs({
    required this.id,
    this.key,
  });

  final int id;

  final _i9.Key? key;

  @override
  String toString() {
    return 'PromptRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i4.ResourcesPage]
class ResourcesRoute extends _i8.PageRouteInfo<void> {
  const ResourcesRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ResourcesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResourcesRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.ResourcesPage();
    },
  );
}

/// generated route for
/// [_i5.SettingsPage]
class SettingsRoute extends _i8.PageRouteInfo<void> {
  const SettingsRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.SettingsPage();
    },
  );
}

/// generated route for
/// [_i6.ShellPage]
class ShellRoute extends _i8.PageRouteInfo<void> {
  const ShellRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShellRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.ShellPage();
    },
  );
}

/// generated route for
/// [_i7.TextPromptsPage]
class TextPromptsRoute extends _i8.PageRouteInfo<void> {
  const TextPromptsRoute({List<_i8.PageRouteInfo>? children})
      : super(
          TextPromptsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TextPromptsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.TextPromptsPage();
    },
  );
}
