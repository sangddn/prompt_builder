import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'core/core.dart';
import 'database/database.dart';
import 'router/router.dart';

class App extends StatefulWidget {
  const App({required this.builder, super.key});

  /// The builder to use for the app.
  final TransitionBuilder builder;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Database>(
          create: (context) => Database(),
          dispose: (context, db) => db.dispose(),
        ),
        StreamProvider<ThemeMode>(
          initialData: kInitialThemeMode,
          create: (context) => streamThemeMode(),
        ),
        StreamProvider<ThemeAccent>(
          initialData: kInitialThemeAccent,
          create: (context) => streamThemeAccent(),
        ),
      ],
      builder: (context, _) {
        final mode = context.watch<ThemeMode>();
        final accent = context.watch<ThemeAccent>();
        return ShadApp.materialRouter(
          title: 'Prompt Builder',
          debugShowCheckedModeBanner: false,
          themeCurve: Curves.ease,
          theme: getTheme(accent, Brightness.light),
          darkTheme: getTheme(accent, Brightness.dark),
          themeMode: mode,
          routerConfig: _appRouter.config(),
          builder: widget.builder,
        );
      },
    );
  }
}

extension AppContext on BuildContext {
  Database get db => read<Database>();
}
