import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'core/core.dart';
import 'database/database.dart';
import 'pages/library_page/library_observer.dart';
import 'router/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = AppRouter();

  @override
  void dispose() {
    Database().closeBoxes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          builder: (context, child) => LibraryObserver(child: child!),
        );
      },
    );
  }
}
