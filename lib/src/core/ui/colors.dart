part of 'ui.dart';

class PColors {
  // ----------------
  // Grays
  // ----------------

  static const _grayLightModeNoOpacity = Color(0xFFE0E0E0);
  static final _grayDarkModeNoOpacity = Colors.grey.shade(.95);
  static final _grayLightMode = Colors.black.replaceOpacity(0.05);
  static final _grayLightModeHighContrast = Colors.black.replaceOpacity(0.085);
  static const _grayDarkMode = Colors.white10;
  static final _grayDarkModeHighContrast = Colors.white.replaceOpacity(0.15);

  static final _lightGrayLightMode = Colors.black.replaceOpacity(0.025);
  static final _lightGrayLightModeHighContrast = Colors.black.replaceOpacity(
    0.035,
  );
  static final _lightGrayDarkMode = Colors.white.replaceOpacity(0.08);
  static final _lightGrayDarkModeHighContrast = Colors.white.replaceOpacity(
    0.12,
  );

  static const _darkGrayLightMode = Colors.black26;
  static const _darkGrayLightModeHighContrast = Colors.black38;
  static const _darkGrayDarkMode = Colors.white30;
  static final _darkGrayDarkModeHighContrast = Colors.white.replaceOpacity(
    0.45,
  );

  static const _textGrayLightMode = Colors.black54;
  static final _textGrayLightModeHighContrast = Colors.black.replaceOpacity(
    0.64,
  );
  static const _textGrayDarkMode = Colors.white54;
  static final _textGrayDarkModeHighContrast = Colors.white.replaceOpacity(
    0.75,
  );

  static final lightGray = CupertinoDynamicColor.withBrightnessAndContrast(
    color: _lightGrayLightMode,
    darkColor: _lightGrayDarkMode,
    highContrastColor: _lightGrayLightModeHighContrast,
    darkHighContrastColor: _lightGrayDarkModeHighContrast,
  );
  static final opaqueLightGray =
      CupertinoDynamicColor.withBrightnessAndContrast(
        color: Colors.grey.tint(.875),
        darkColor: Colors.grey.shade(.85),
        highContrastColor: Colors.grey.tint(.8),
        darkHighContrastColor: Colors.grey.shade(.7),
      );
  static final gray = CupertinoDynamicColor.withBrightnessAndContrast(
    color: _grayLightMode,
    darkColor: _grayDarkMode,
    highContrastColor: _grayLightModeHighContrast,
    darkHighContrastColor: _grayDarkModeHighContrast,
  );
  static final opagueGray = CupertinoDynamicColor.withBrightnessAndContrast(
    color: _grayLightModeNoOpacity,
    darkColor: _grayDarkModeNoOpacity,
    highContrastColor: _grayLightModeNoOpacity,
    darkHighContrastColor: _grayDarkModeNoOpacity,
  );
  static final darkGray = CupertinoDynamicColor.withBrightnessAndContrast(
    color: _darkGrayLightMode,
    darkColor: _darkGrayDarkMode,
    highContrastColor: _darkGrayLightModeHighContrast,
    darkHighContrastColor: _darkGrayDarkModeHighContrast,
  );
  static final textGray = CupertinoDynamicColor.withBrightnessAndContrast(
    color: _textGrayLightMode,
    darkColor: _textGrayDarkMode,
    highContrastColor: _textGrayLightModeHighContrast,
    darkHighContrastColor: _textGrayDarkModeHighContrast,
  );
}

extension ColorUtilsExtension on Color {
  Color makePastel() => ColorUtils.getPastelColorFromHexString(toString());
  Color brighten() => ColorUtils.getBrightColorFromHexString(toString());

  String toHexStringRGB() {
    return '${(r * 255).round().toRadixString(16).padLeft(2, '0')}'
        '${(g * 255).round().toRadixString(16).padLeft(2, '0')}'
        '${(b * 255).round().toRadixString(16).padLeft(2, '0')}';
  }

  Color withOpacityFactor(double factor) {
    return withValues(
      alpha: (a * factor).clamp(0.0, 1.0),
      red: r,
      green: g,
      blue: b,
    );
  }

  Color replaceOpacity(double opacity) {
    return withValues(alpha: opacity, red: r, green: g, blue: b);
  }

  Color invert() {
    return withValues(
      alpha: 1.0 - a,
      red: 1.0 - r,
      green: 1.0 - g,
      blue: 1.0 - b,
    );
  }
}

extension ColorTintsShades on Color {
  /// Internal method to convert the Color to a list of RGB values.
  List<double> _toRgb() {
    return [r, g, b];
  }

  /// Internal method to create a Color from RGB values.
  static Color _fromRgb(double r, double g, double b, [double opacity = 1.0]) {
    // return Color.from(red: r, green: g, blue: b, alpha: opacity);
    return Color.from(alpha: opacity, red: r, green: g, blue: b);
  }

  /// Internal method to create a tint of the Color.
  Color tint(double factor) {
    assert(factor >= 0 && factor <= 1, 'Factor must be between 0 and 1');

    final rgb = _toRgb();
    final tintedRgb = rgb.map((c) => c + ((1.0 - c) * factor)).toList();

    return _fromRgb(tintedRgb[0], tintedRgb[1], tintedRgb[2], a);
  }

  /// Internal method to create a shade of the Color.
  Color shade(double factor) {
    assert(factor >= 0 && factor <= 1, 'Factor must be between 0 and 1');

    final rgb = _toRgb();
    final shadedRgb = rgb.map((c) => c * (1.0 - factor)).toList();
    return _fromRgb(shadedRgb[0], shadedRgb[1], shadedRgb[2], a);
  }

  /// Dynamically create a tint or shade of the Color based on brightness.
  ///
  /// If the theme is light, the Color will be tinted with [tintFactor].
  /// If the theme is dark, the Color will be shaded with [shadeFactor], or [tintFactor]
  /// if [shadeFactor] is not provided.
  Color adjustForBrightness(
    BuildContext context,
    double tintFactor, [
    double? shadeFactor,
  ]) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? shade(shadeFactor ?? tintFactor) : tint(tintFactor);
  }

  /// Dynamically create a tint of the Color based on brightness.
  Color resolveTint(
    BuildContext context,
    double lightFactor,
    double darkFactor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? tint(darkFactor) : tint(lightFactor);
  }

  // Tint methods
  Color get tint10 => tint(0.1);
  Color get tint20 => tint(0.2);
  Color get tint30 => tint(0.3);
  Color get tint40 => tint(0.4);
  Color get tint50 => tint(0.5);
  Color get tint60 => tint(0.6);
  Color get tint70 => tint(0.7);
  Color get tint80 => tint(0.8);
  Color get tint90 => tint(0.9);

  // Shade methods
  Color get shade10 => shade(0.1);
  Color get shade20 => shade(0.2);
  Color get shade30 => shade(0.3);
  Color get shade40 => shade(0.4);
  Color get shade50 => shade(0.5);
  Color get shade60 => shade(0.6);
  Color get shade70 => shade(0.7);
  Color get shade80 => shade(0.8);
  Color get shade90 => shade(0.9);
}

extension ThemeColorUtils on CupertinoDynamicColor {
  Color resolveWithTheme(ShadThemeData theme, {bool isHighContrast = false}) {
    final lerpValue = theme.interpolationValue;
    return isHighContrast
        ? Color.lerp(highContrastColor, darkHighContrastColor, lerpValue)!
        : Color.lerp(color, darkColor, lerpValue)!;
  }

  Color reverseResolveWithTheme(
    ShadThemeData theme, {
    bool isHighContrast = false,
  }) {
    final modifiedTheme = theme.copyWith(
      brightness:
          theme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
    );
    return resolveWithTheme(modifiedTheme, isHighContrast: isHighContrast);
  }
}

abstract final class ColorUtils {
  static Color fromHexString(String hexString) {
    final hex = hexString.replaceFirst('#', '');
    final r = int.parse(hex.substring(0, 2), radix: 16);
    final g = int.parse(hex.substring(2, 4), radix: 16);
    final b = int.parse(hex.substring(4, 6), radix: 16);
    return Color.fromARGB(255, r, g, b);
  }

  static Color getPastelColorFromHexString(String hexString) {
    final random = Random(hexString.hashCode);
    final hue = random.nextDouble() * 360;
    const saturation = 0.9;
    const lightness = 0.45;
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  static Color getBrightColorFromHexString(String hexString) {
    final random = Random(hexString.hashCode);
    final hue = random.nextDouble() * 360;
    const saturation = 0.9;
    const lightness = 0.7;
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }
}
