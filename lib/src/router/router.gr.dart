// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/cupertino.dart' as _i13;
import 'package:flutter/material.dart' as _i12;
import 'package:prompt_builder/src/pages/library_page/library_page.dart' as _i1;
import 'package:prompt_builder/src/pages/project_page/project_page.dart' as _i3;
import 'package:prompt_builder/src/pages/projects_page/projects_page.dart'
    as _i4;
import 'package:prompt_builder/src/pages/prompt_page/prompt_page.dart' as _i5;
import 'package:prompt_builder/src/pages/resources_page/resources_page.dart'
    as _i6;
import 'package:prompt_builder/src/pages/settings_page/settings_page.dart'
    as _i7;
import 'package:prompt_builder/src/pages/shell_page/shell_page.dart' as _i8;
import 'package:prompt_builder/src/pages/snippet_page/snippet_page.dart' as _i9;
import 'package:prompt_builder/src/pages/snippets_page/snippets_page.dart'
    as _i10;
import 'package:prompt_builder/src/router/router.dart' as _i2;

/// generated route for
/// [_i1.LibraryPage]
class LibraryRoute extends _i11.PageRouteInfo<void> {
  const LibraryRoute({List<_i11.PageRouteInfo>? children})
      : super(
          LibraryRoute.name,
          initialChildren: children,
        );

  static const String name = 'LibraryRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.LibraryPage();
    },
  );
}

/// generated route for
/// [_i2.LibraryShellPage]
class LibraryShellRoute extends _i11.PageRouteInfo<void> {
  const LibraryShellRoute({List<_i11.PageRouteInfo>? children})
      : super(
          LibraryShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'LibraryShellRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.LibraryShellPage();
    },
  );
}

/// generated route for
/// [_i3.ProjectPage]
class ProjectRoute extends _i11.PageRouteInfo<ProjectRouteArgs> {
  ProjectRoute({
    required int id,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          ProjectRoute.name,
          args: ProjectRouteArgs(
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ProjectRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProjectRouteArgs>();
      return _i3.ProjectPage(
        id: args.id,
        key: args.key,
      );
    },
  );
}

class ProjectRouteArgs {
  const ProjectRouteArgs({
    required this.id,
    this.key,
  });

  final int id;

  final _i12.Key? key;

  @override
  String toString() {
    return 'ProjectRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i4.ProjectsPage]
class ProjectsRoute extends _i11.PageRouteInfo<void> {
  const ProjectsRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ProjectsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.ProjectsPage();
    },
  );
}

/// generated route for
/// [_i2.ProjectsShellPage]
class ProjectsShellRoute extends _i11.PageRouteInfo<void> {
  const ProjectsShellRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ProjectsShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectsShellRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.ProjectsShellPage();
    },
  );
}

/// generated route for
/// [_i5.PromptPage]
class PromptRoute extends _i11.PageRouteInfo<PromptRouteArgs> {
  PromptRoute({
    required int id,
    _i13.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          PromptRoute.name,
          args: PromptRouteArgs(
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PromptRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PromptRouteArgs>();
      return _i5.PromptPage(
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'PromptRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i6.ResourcesPage]
class ResourcesRoute extends _i11.PageRouteInfo<void> {
  const ResourcesRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ResourcesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResourcesRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.ResourcesPage();
    },
  );
}

/// generated route for
/// [_i7.SettingsPage]
class SettingsRoute extends _i11.PageRouteInfo<void> {
  const SettingsRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i7.SettingsPage();
    },
  );
}

/// generated route for
/// [_i8.ShellPage]
class ShellRoute extends _i11.PageRouteInfo<void> {
  const ShellRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShellRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i8.ShellPage();
    },
  );
}

/// generated route for
/// [_i9.SnippetPage]
class SnippetRoute extends _i11.PageRouteInfo<SnippetRouteArgs> {
  SnippetRoute({
    _i12.VoidCallback? onSaved,
    required int id,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          SnippetRoute.name,
          args: SnippetRouteArgs(
            onSaved: onSaved,
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SnippetRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SnippetRouteArgs>();
      return _i9.SnippetPage(
        onSaved: args.onSaved,
        id: args.id,
        key: args.key,
      );
    },
  );
}

class SnippetRouteArgs {
  const SnippetRouteArgs({
    this.onSaved,
    required this.id,
    this.key,
  });

  final _i12.VoidCallback? onSaved;

  final int id;

  final _i12.Key? key;

  @override
  String toString() {
    return 'SnippetRouteArgs{onSaved: $onSaved, id: $id, key: $key}';
  }
}

/// generated route for
/// [_i10.SnippetsPage]
class SnippetsRoute extends _i11.PageRouteInfo<void> {
  const SnippetsRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SnippetsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SnippetsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.SnippetsPage();
    },
  );
}

/// generated route for
/// [_i2.SnippetsShellPage]
class SnippetsShellRoute extends _i11.PageRouteInfo<void> {
  const SnippetsShellRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SnippetsShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'SnippetsShellRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.SnippetsShellPage();
    },
  );
}
