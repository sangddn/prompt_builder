// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/cupertino.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:prompt_builder/src/database/database.dart' as _i9;
import 'package:prompt_builder/src/pages/library_page/library_page.dart' as _i1;
import 'package:prompt_builder/src/pages/prompt_page/prompt_page.dart' as _i3;
import 'package:prompt_builder/src/pages/resources_page/resources_page.dart'
    as _i4;
import 'package:prompt_builder/src/pages/settings_page/settings_page.dart'
    as _i5;
import 'package:prompt_builder/src/pages/shell_page/shell_page.dart' as _i6;
import 'package:prompt_builder/src/pages/snippets_page/snippets_page.dart'
    as _i7;
import 'package:prompt_builder/src/router/router.dart' as _i2;

/// generated route for
/// [_i1.LibraryPage]
class LibraryRoute extends _i8.PageRouteInfo<LibraryRouteArgs> {
  LibraryRoute({
    _i9.Database? database,
    _i10.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          LibraryRoute.name,
          args: LibraryRouteArgs(
            database: database,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'LibraryRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LibraryRouteArgs>(orElse: () => const LibraryRouteArgs());
      return _i1.LibraryPage(
        database: args.database,
        key: args.key,
      );
    },
  );
}

class LibraryRouteArgs {
  const LibraryRouteArgs({
    this.database,
    this.key,
  });

  final _i9.Database? database;

  final _i10.Key? key;

  @override
  String toString() {
    return 'LibraryRouteArgs{database: $database, key: $key}';
  }
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
    _i9.Database? database,
    required int id,
    _i11.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          PromptRoute.name,
          args: PromptRouteArgs(
            database: database,
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
        database: args.database,
        id: args.id,
        key: args.key,
      );
    },
  );
}

class PromptRouteArgs {
  const PromptRouteArgs({
    this.database,
    required this.id,
    this.key,
  });

  final _i9.Database? database;

  final int id;

  final _i11.Key? key;

  @override
  String toString() {
    return 'PromptRouteArgs{database: $database, id: $id, key: $key}';
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
/// [_i7.SnippetsPage]
class SnippetsRoute extends _i8.PageRouteInfo<void> {
  const SnippetsRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SnippetsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SnippetsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SnippetsPage();
    },
  );
}
