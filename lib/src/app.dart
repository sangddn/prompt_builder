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
  final _themeModeStream = _streamThemeMode();

  @override
  void dispose() {
    Database().closeBoxes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _initialThemeMode,
      stream: _themeModeStream,
      builder: (context, snapshot) {
        return ShadApp.materialRouter(
          title: 'Prompt Builder',
          debugShowCheckedModeBanner: false,
          themeCurve: Curves.ease,
          theme: kLightTheme,
          darkTheme: kDarkTheme,
          themeMode: snapshot.data ?? _initialThemeMode,
          routerConfig: _appRouter.config(),
          builder: (context, child) => LibraryObserver(child: child!),
        );
      },
    );
  }
}

const _themeModeKey = 'theme-mode';
const _initialThemeMode = ThemeMode.system;
Stream<ThemeMode> _streamThemeMode() => Database()
    .stringRef //
    .watch(key: _themeModeKey)
    .map(
      (event) => ThemeMode.values.firstWhere(
        (element) => element.toString() == event.value,
        orElse: () => _initialThemeMode,
      ),
    );

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
  final _themeModeStream = _streamThemeMode();

  @override
  Widget build(BuildContext context) {
    final themedChild = StreamBuilder(
      initialData: _initialThemeMode,
      stream: _themeModeStream,
      builder: (context, snapshot) {
        final mode = snapshot.data ?? _initialThemeMode;
        final theme = mode == ThemeMode.dark
            ? kDarkTheme
            : mode == ThemeMode.light
                ? kLightTheme
                : MediaQuery.platformBrightnessOf(context) == Brightness.dark
                    ? kDarkTheme
                    : kLightTheme;
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
