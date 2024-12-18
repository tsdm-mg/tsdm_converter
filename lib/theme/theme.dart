import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.0.2.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///  theme: AppTheme.light,
///  darkTheme: AppTheme.dark,
///  :
/// );
sealed class AppTheme {
  static final String? _fontFamily =
      defaultTargetPlatform == TargetPlatform.windows
          ? 'Microsoft YaHei UI'
          : null;

  static const FlexSubThemesData _subThemesData = FlexSubThemesData(
    inputDecoratorBorderType: FlexInputBorderType.outline,
    alignedDropdown: true,
    tooltipRadius: 4,
    tooltipSchemeColor: SchemeColor.inverseSurface,
    tooltipOpacity: 0.9,
    snackBarElevation: 6,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    navigationRailUseIndicator: true,
    navigationRailLabelType: NavigationRailLabelType.all,
  );

  /// The defined light theme.
  static ThemeData light = FlexThemeData.light(
    fontFamily: _fontFamily,
    scheme: FlexScheme.outerSpace,
    subThemesData: _subThemesData,
    keyColors: const FlexKeyColors(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  /// The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    fontFamily: _fontFamily,
    scheme: FlexScheme.outerSpace,
    subThemesData: _subThemesData,
    keyColors: const FlexKeyColors(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
