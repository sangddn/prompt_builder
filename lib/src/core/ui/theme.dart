part of 'ui.dart';

final kLightTheme = ShadThemeData(
  brightness: Brightness.light,
  colorScheme: const ShadZincColorScheme.light(background: Color(0xffFAFAFA)),
  switchTheme: const ShadSwitchTheme(margin: 0.0),
);

final kDarkTheme = ShadThemeData(
  brightness: Brightness.dark,
  colorScheme: const ShadZincColorScheme.dark(),
  switchTheme: const ShadSwitchTheme(margin: 1.0),
);

extension TextStyleUtils on TextStyle {
  TextStyle get w300 =>
      copyWith(fontVariations: const [FontVariation.weight(300)]);
  TextStyle get w400 =>
      copyWith(fontVariations: const [FontVariation.weight(400)]);
  TextStyle get w500 =>
      copyWith(fontVariations: const [FontVariation.weight(500)]);
  TextStyle get w600 =>
      copyWith(fontVariations: const [FontVariation.weight(600)]);
  TextStyle get w700 =>
      copyWith(fontVariations: const [FontVariation.weight(700)]);
  TextStyle get w800 =>
      copyWith(fontVariations: const [FontVariation.weight(800)]);
  TextStyle get w900 =>
      copyWith(fontVariations: const [FontVariation.weight(900)]);

  /// Modifies the weight of the font.
  ///
  /// Fractional weight deltas are only supported for variable fonts.
  /// For non-variable fonts such as, [delta] will be rounded to the nearest
  /// integer.
  ///
  /// A [delta] value of `0.0` will return the current [TextStyle] without any
  /// changes. A non-zero [delta] value will be added the weight in multiples
  /// of `100`. Typically, the weight is clamped below by `100` and above by
  /// `900`, but the exact effect can vary depending on the font.
  ///
  TextStyle withWeight(double delta) {
    if (delta == 0.0) {
      return this;
    }
    final weight = fontVariations
        ?.firstWhereOrNull((variation) => variation.axis == 'wght')
        ?.value as num?;
    if (weight != null && fontVariations == null) {
      return apply(fontWeightDelta: delta.round());
    }
    return copyWith(
      fontVariations: [FontVariation.weight((weight ?? 400) + delta * 100)],
    );
  }

  /// Modifies the letter spacing of the font if the language is not in the
  /// [avoidedLangs] list.
  ///
  /// Defaults to `0.0`, which is the normal letter spacing. A positive value
  /// will increase the letter spacing, and a negative value will decrease it.
  ///
  TextStyle withLetterSpacing(double delta) {
    return apply(letterSpacingDelta: delta);
  }

  /// Modifies the width of the font. This is only supported
  /// for variable fonts such as [kLabelFontFamily].
  ///
  /// Note that [kFontFamily] does not support width modification.
  ///
  /// Defaults to `1.0`, which is the normal width. A value greater
  /// than `1.0` will expand the width, and a value less than `1.0`
  /// will condense the width.
  ///
  // TextStyle modifyWidth([double width = 1.0]) => copyWith(
  //       fontVariations: [FontVariation.width(width * 100.0)],
  //     );

  TextStyle enableFeature(String feature) {
    return copyWith(
      fontFeatures: [
        ...?fontFeatures,
        FontFeature.enable(feature),
      ],
    );
  }

  TextStyle enableFeatures(List<String> features) {
    return copyWith(
      fontFeatures: [
        ...?fontFeatures,
        ...features.map(FontFeature.enable),
      ],
    );
  }

  TextStyle disableFeature(String feature) {
    return copyWith(
      fontFeatures: [
        ...?fontFeatures,
        FontFeature.disable(feature),
      ],
    );
  }

  TextStyle disableFeatures(List<String> features) {
    return copyWith(
      fontFeatures: [
        ...?fontFeatures,
        ...features.map(FontFeature.disable),
      ],
    );
  }

  TextStyle get lightWeight => w300;
  TextStyle get regularWeight => w400;
  TextStyle get mediumWeight => w500;
  TextStyle get tighterLetter => withLetterSpacing(-0.5);
  TextStyle get looserLetter => withLetterSpacing(0.5);
}

extension BrightnessCheckData on ShadThemeData {
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;

  /// Returns the interpolation value between different [Theme]s when app's
  /// [Theme] animates.
  ///
  /// Returns 0.0 when the theme is light, 1.0 when the theme is dark.
  ///
  /// The app's [Theme] at any point is not only determined the animation state
  /// of [AnimatedTheme], which is not 0.0 or 1.0 when user is switching between
  /// light and dark themes.
  ///
  /// [ThemeExtension] doesn't have the flexibility we need, so this method
  /// calculates the current "lerp value" between the light and dark themes, so
  /// even custom colors or numbers animates.
  ///
  /// The trick here is to use the [switchTheme.splashRadius] property, which
  /// is a double value that we define to animate between 0.0 and 1.0. This
  /// value is not used anywhere else in the app.
  ///
  double get interpolationValue => switchTheme.margin!;

  double resolveNum<T extends num>(
    T light,
    T dark, {
    ThemeMode mode = ThemeMode.system,
    bool inverse = false,
  }) {
    final a = (inverse ? dark : light).toDouble();
    final b = (inverse ? light : dark).toDouble();
    switch (mode) {
      case ThemeMode.light:
        return a;
      case ThemeMode.dark:
        return b;
      case ThemeMode.system:
        final a = light.toDouble();
        final b = dark.toDouble();
        final t = interpolationValue;
        if (a == b || (a.isNaN) && (b.isNaN)) {
          return a;
        }
        assert(
          a.isFinite,
          'Cannot interpolate between finite and non-finite values',
        );
        assert(
          b.isFinite,
          'Cannot interpolate between finite and non-finite values',
        );
        assert(
          t.isFinite,
          't must be finite when interpolating between values',
        );
        return a * (1.0 - t) + b * t;
    }
  }

  BorderSide resolveBorderSide(BorderSide light, BorderSide dark) {
    return BorderSide.lerp(light, dark, interpolationValue);
  }

  /// Resolves any type [T] between [light] and [dark] based on the current
  /// [Theme.brightness] and an optional [mode].
  ///
  /// Should not be used in favor of type-specific methods like [resolveColor]
  /// or [resolveNum] when possible, since this method does not interpolate
  /// between the two values when the theme is animating.
  ///
  T resolveBrightness<T>(
    T light,
    T dark, [
    ThemeMode mode = ThemeMode.system,
  ]) {
    switch (mode) {
      case ThemeMode.system:
        return isDark ? dark : light;
      case ThemeMode.light:
        return light;
      case ThemeMode.dark:
        return dark;
    }
  }

  Color resolveColor(
    Color light,
    Color dark, {
    bool inverse = false,
    bool isHighContrast = false,
    ThemeMode mode = ThemeMode.system,
  }) {
    switch (mode) {
      case ThemeMode.light:
        return inverse ? dark : light;
      case ThemeMode.dark:
        return inverse ? light : dark;
      case ThemeMode.system:
        final dynamicColor =
            CupertinoDynamicColor.withBrightness(color: light, darkColor: dark);
        return inverse
            ? dynamicColor.reverseResolveWithTheme(
                this,
                isHighContrast: isHighContrast,
              )
            : dynamicColor.resolveWithTheme(
                this,
                isHighContrast: isHighContrast,
              );
    }
  }
}

extension ThemeUtils on BuildContext {
  ThemeData get materialTheme => Theme.of(this);
  ShadThemeData get theme => ShadTheme.of(this);
  ShadColorScheme get colorScheme => theme.colorScheme;
}
