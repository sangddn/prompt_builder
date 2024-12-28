import 'package:flutter/material.dart';
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
  final _themeModeStream = streamThemeMode();
  final _themeAccentStream = streamThemeAccent();

  @override
  void dispose() {
    Database().closeBoxes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder2(
      initialValue1: kInitialThemeMode,
      initialValue2: kInitialThemeAccent,
      stream1: _themeModeStream,
      stream2: _themeAccentStream,
      builder: (context, snapshot1, snapshot2) {
        final mode = snapshot1.data ?? kInitialThemeMode;
        final accent = snapshot2.data ?? kInitialThemeAccent;
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

/// A parent widget that re-themes its child based on the user's theme preference
/// and the system's platform brightness.
///
/// Typically used for spawned windows or dialogs.
///
class ReTheme extends StatefulWidget {
  const ReTheme({
    this.includeNewScaffoldMessenger = false,
    required this.builder,
    super.key,
  });

  /// Whether to include a new [ScaffoldMessenger] in the [builder]'s context.
  ///
  /// Including a new [ScaffoldMessenger] may be useful for spawned windows or
  /// dialogs when we don't want SnackBar messages to be displayed in the main
  /// Navigator and the dialog at the same time.
  ///
  final bool includeNewScaffoldMessenger;
  final WidgetBuilder builder;

  @override
  State<ReTheme> createState() => _ReThemeState();
}

class _ReThemeState extends State<ReTheme> {
  final _themeModeStream = streamThemeMode();
  final _themeAccentStream = streamThemeAccent();

  @override
  Widget build(BuildContext context) {
    final themedChild = StreamBuilder2(
      initialValue1: kInitialThemeMode,
      initialValue2: kInitialThemeAccent,
      stream1: _themeModeStream,
      stream2: _themeAccentStream,
      builder: (context, snapshot1, snapshot2) {
        final mode = snapshot1.data ?? kInitialThemeMode;
        final accent = snapshot2.data ?? kInitialThemeAccent;
        final brightness = mode == ThemeMode.dark ||
                (mode == ThemeMode.system &&
                    MediaQuery.platformBrightnessOf(context) == Brightness.dark)
            ? Brightness.dark
            : Brightness.light;
        final theme = getTheme(accent, brightness);
        return ShadAnimatedTheme(
          data: theme,
          child: Builder(builder: widget.builder),
        );
      },
    );
    if (widget.includeNewScaffoldMessenger) {
      return ScaffoldMessenger(child: themedChild);
    }
    return themedChild;
  }
}
