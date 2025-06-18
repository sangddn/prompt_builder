// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/cupertino.dart' as _i12;
import 'package:flutter/material.dart' as _i11;
import 'package:prompt_builder/src/pages/library_page/library_page.dart' as _i2;
import 'package:prompt_builder/src/pages/project_page/project_page.dart' as _i3;
import 'package:prompt_builder/src/pages/projects_page/projects_page.dart'
    as _i4;
import 'package:prompt_builder/src/pages/prompt_page/prompt_page.dart' as _i5;
import 'package:prompt_builder/src/pages/resources_page/resources_page.dart'
    as _i6;
import 'package:prompt_builder/src/pages/settings_page/settings_page.dart'
    as _i7;
import 'package:prompt_builder/src/pages/shell_page/shell_page.dart' as _i1;
import 'package:prompt_builder/src/pages/snippet_page/snippet_page.dart' as _i8;
import 'package:prompt_builder/src/pages/snippets_page/snippets_page.dart'
    as _i9;

/// generated route for
/// [_i1.AppShellPage]
class AppShellRoute extends _i10.PageRouteInfo<void> {
  const AppShellRoute({List<_i10.PageRouteInfo>? children})
    : super(AppShellRoute.name, initialChildren: children);

  static const String name = 'AppShellRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppShellPage();
    },
  );
}

/// generated route for
/// [_i2.LibraryPage]
class LibraryRoute extends _i10.PageRouteInfo<void> {
  const LibraryRoute({List<_i10.PageRouteInfo>? children})
    : super(LibraryRoute.name, initialChildren: children);

  static const String name = 'LibraryRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i2.LibraryPage();
    },
  );
}

/// generated route for
/// [_i1.MainTabsPage]
class MainTabsRoute extends _i10.PageRouteInfo<void> {
  const MainTabsRoute({List<_i10.PageRouteInfo>? children})
    : super(MainTabsRoute.name, initialChildren: children);

  static const String name = 'MainTabsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.MainTabsPage();
    },
  );
}

/// generated route for
/// [_i3.ProjectPage]
class ProjectRoute extends _i10.PageRouteInfo<ProjectRouteArgs> {
  ProjectRoute({
    required int id,
    _i11.Key? key,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         ProjectRoute.name,
         args: ProjectRouteArgs(id: id, key: key),
         initialChildren: children,
       );

  static const String name = 'ProjectRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProjectRouteArgs>();
      return _i3.ProjectPage(id: args.id, key: args.key);
    },
  );
}

class ProjectRouteArgs {
  const ProjectRouteArgs({required this.id, this.key});

  final int id;

  final _i11.Key? key;

  @override
  String toString() {
    return 'ProjectRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i4.ProjectsPage]
class ProjectsRoute extends _i10.PageRouteInfo<void> {
  const ProjectsRoute({List<_i10.PageRouteInfo>? children})
    : super(ProjectsRoute.name, initialChildren: children);

  static const String name = 'ProjectsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.ProjectsPage();
    },
  );
}

/// generated route for
/// [_i5.PromptPage]
class PromptRoute extends _i10.PageRouteInfo<PromptRouteArgs> {
  PromptRoute({
    required int id,
    _i12.Key? key,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         PromptRoute.name,
         args: PromptRouteArgs(id: id, key: key),
         initialChildren: children,
       );

  static const String name = 'PromptRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PromptRouteArgs>();
      return _i5.PromptPage(id: args.id, key: args.key);
    },
  );
}

class PromptRouteArgs {
  const PromptRouteArgs({required this.id, this.key});

  final int id;

  final _i12.Key? key;

  @override
  String toString() {
    return 'PromptRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i6.ResourcesPage]
class ResourcesRoute extends _i10.PageRouteInfo<void> {
  const ResourcesRoute({List<_i10.PageRouteInfo>? children})
    : super(ResourcesRoute.name, initialChildren: children);

  static const String name = 'ResourcesRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.ResourcesPage();
    },
  );
}

/// generated route for
/// [_i7.SettingsPage]
class SettingsRoute extends _i10.PageRouteInfo<void> {
  const SettingsRoute({List<_i10.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.SettingsPage();
    },
  );
}

/// generated route for
/// [_i8.SnippetPage]
class SnippetRoute extends _i10.PageRouteInfo<SnippetRouteArgs> {
  SnippetRoute({
    _i11.VoidCallback? onSaved,
    required int id,
    _i11.Key? key,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         SnippetRoute.name,
         args: SnippetRouteArgs(onSaved: onSaved, id: id, key: key),
         initialChildren: children,
       );

  static const String name = 'SnippetRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SnippetRouteArgs>();
      return _i8.SnippetPage(onSaved: args.onSaved, id: args.id, key: args.key);
    },
  );
}

class SnippetRouteArgs {
  const SnippetRouteArgs({this.onSaved, required this.id, this.key});

  final _i11.VoidCallback? onSaved;

  final int id;

  final _i11.Key? key;

  @override
  String toString() {
    return 'SnippetRouteArgs{onSaved: $onSaved, id: $id, key: $key}';
  }
}

/// generated route for
/// [_i9.SnippetsPage]
class SnippetsRoute extends _i10.PageRouteInfo<void> {
  const SnippetsRoute({List<_i10.PageRouteInfo>? children})
    : super(SnippetsRoute.name, initialChildren: children);

  static const String name = 'SnippetsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.SnippetsPage();
    },
  );
}
