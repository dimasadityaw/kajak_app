import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

String _appTheme = "primary";

/// Helper class for managing themes and colors.
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    //throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedCustomColor.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    //return theme from map

    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    //throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedColorScheme.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    //return theme from map

    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.primary,
      textSelectionTheme: TextSelectionThemeData(
        // cursorColor: Colors.red,
        selectionColor: appTheme.gray300,
        selectionHandleColor: Colors.brown,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.black900,
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.onPrimary.withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        labelLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 12.fSize,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onPrimary.withOpacity(1),
          fontSize: 20.fSize,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 16.fSize,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 14.fSize,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    // Primary colors
    primary: Color(0XFFFFFFFF),
    primaryContainer: Color(0XFFCCCCCC),
    secondary: Color(0XFFCCCCCC),
    secondaryContainer: Color(0X893B271E),
    tertiary: Color(0XFFCCCCCC),
    tertiaryContainer: Color(0X893B271E),

    // Background colors
    background: Color(0XFFCCCCCC),

    // Surface colors
    surface: Color(0XFFCCCCCC),
    surfaceTint: Color(0X893B271E),
    surfaceVariant: Color(0X893B271E),

    // Error colors
    error: Color(0X893B271E),
    errorContainer: Color(0XFFCCCCCC),
    onError: Color(0XFFF2F2F2),
    onErrorContainer: Color(0XFF1E1E1E),

    // On colors(text colors)
    onBackground: Color(0XFF1E1E1E),
    onInverseSurface: Color(0XFFF2F2F2),
    onPrimary: Color(0X893B271E),
    onPrimaryContainer: Color(0XFF1E1E1E),
    onSecondary: Color(0XFF1E1E1E),
    onSecondaryContainer: Color(0XFFF2F2F2),
    onTertiary: Color(0XFF1E1E1E),
    onTertiaryContainer: Color(0XFFF2F2F2),

    // Other colors
    outline: Color(0X893B271E),
    outlineVariant: Color(0XFFCCCCCC),
    scrim: Color(0XFFCCCCCC),
    shadow: Color(0X893B271E),

    // Inverse colors
    inversePrimary: Color(0XFFCCCCCC),
    inverseSurface: Color(0X893B271E),

    // Pending colors
    onSurface: Color(0XFF1E1E1E),
    onSurfaceVariant: Color(0XFFF2F2F2),
  );
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // Black
  Color get black900 => Color(0XFF000000);

  // BlueGray
  Color get blueGray100 => Color(0XFFD1D1D6);
  Color get blueGray10001 => Color(0XFFD9D9D9);
  Color get blueGray400 => Color(0XFF888888);

  // Gray
  Color get gray300 => Color(0XFFE5E5EA);
  Color get gray50 => Color(0XFFFAFAFA);

  // LightGreen
  Color get lightGreen200 => Color(0XFFAFF9A8);

  // Orange
  Color get orange100 => Color(0XFFEFDFBB);

  // White
  Color get whiteA700 => Color(0XFFFDFDFF);
}

PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
