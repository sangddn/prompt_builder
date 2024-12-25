// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:prompt_builder/src/pages/library_page/library_page.dart' as _i1;
import 'package:prompt_builder/src/pages/prompt_page/prompt_page.dart' as _i2;
import 'package:prompt_builder/src/pages/resources_page/resources_page.dart'
    as _i3;
import 'package:prompt_builder/src/pages/settings_page/settings_page.dart'
    as _i4;
import 'package:prompt_builder/src/pages/shell_page/shell_page.dart' as _i5;
import 'package:prompt_builder/src/pages/text_prompts_page/text_prompts_page.dart'
    as _i6;

/// generated route for
/// [_i1.LibraryPage]
class LibraryRoute extends _i7.PageRouteInfo<void> {
  const LibraryRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LibraryRoute.name,
          initialChildren: children,
        );

  static const String name = 'LibraryRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.LibraryPage();
    },
  );
}

/// generated route for
/// [_i2.PromptPage]
class PromptRoute extends _i7.PageRouteInfo<PromptRouteArgs> {
  PromptRoute({
    required int id,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          PromptRoute.name,
          args: PromptRouteArgs(
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PromptRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PromptRouteArgs>();
      return _i2.PromptPage(
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

  final _i8.Key? key;

  @override
  String toString() {
    return 'PromptRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i3.ResourcesPage]
class ResourcesRoute extends _i7.PageRouteInfo<void> {
  const ResourcesRoute({List<_i7.PageRouteInfo>? children})
      : super(
          ResourcesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResourcesRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.ResourcesPage();
    },
  );
}

/// generated route for
/// [_i4.SettingsPage]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.SettingsPage();
    },
  );
}

/// generated route for
/// [_i5.ShellPage]
class ShellRoute extends _i7.PageRouteInfo<void> {
  const ShellRoute({List<_i7.PageRouteInfo>? children})
      : super(
          ShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShellRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.ShellPage();
    },
  );
}

/// generated route for
/// [_i6.TextPromptsPage]
class TextPromptsRoute extends _i7.PageRouteInfo<void> {
  const TextPromptsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          TextPromptsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TextPromptsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.TextPromptsPage();
    },
  );
}
