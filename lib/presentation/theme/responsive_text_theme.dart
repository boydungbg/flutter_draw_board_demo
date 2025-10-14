import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/core/extensions/responsive_extension.dart';

/// A responsive text theme that adapts to screen sizes
class ResponsiveTextTheme {
  final BuildContext context;

  ResponsiveTextTheme(this.context);

  double get _multiplier => context.responsiveFontSizeMultiplier;

  /// Display text styles (largest)
  TextStyle get displayLarge => TextStyle(
        fontSize: 57 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  TextStyle get displayMedium => TextStyle(
        fontSize: 45 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      );

  TextStyle get displaySmall => TextStyle(
        fontSize: 36 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      );

  /// Headline text styles
  TextStyle get headlineLarge => TextStyle(
        fontSize: 32 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      );

  TextStyle get headlineMedium => TextStyle(
        fontSize: 28 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
      );

  TextStyle get headlineSmall => TextStyle(
        fontSize: 24 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      );

  /// Title text styles
  TextStyle get titleLarge => TextStyle(
        fontSize: 22 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.27,
      );

  TextStyle get titleMedium => TextStyle(
        fontSize: 16 * _multiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      );

  TextStyle get titleSmall => TextStyle(
        fontSize: 14 * _multiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  /// Label text styles (for buttons, etc.)
  TextStyle get labelLarge => TextStyle(
        fontSize: 14 * _multiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  TextStyle get labelMedium => TextStyle(
        fontSize: 12 * _multiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  TextStyle get labelSmall => TextStyle(
        fontSize: 11 * _multiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  /// Body text styles
  TextStyle get bodyLarge => TextStyle(
        fontSize: 16 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      );

  TextStyle get bodyMedium => TextStyle(
        fontSize: 14 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  TextStyle get bodySmall => TextStyle(
        fontSize: 12 * _multiplier,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  /// Responsive text styles based on context
  TextStyle get responsiveDisplayLarge => context.responsiveValue(
        mobile: displaySmall,
        tablet: displayMedium,
        desktop: displayLarge,
      );

  TextStyle get responsiveHeadline => context.responsiveValue(
        mobile: headlineSmall,
        tablet: headlineMedium,
        desktop: headlineLarge,
      );

  TextStyle get responsiveTitle => context.responsiveValue(
        mobile: titleSmall,
        tablet: titleMedium,
        desktop: titleLarge,
      );

  TextStyle get responsiveBody => context.responsiveValue(
        mobile: bodySmall,
        tablet: bodyMedium,
        desktop: bodyLarge,
      );

  /// Custom responsive text style
  TextStyle responsive({
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    Color? color,
  }) {
    final fontSize = context.responsiveValue(
      mobile: mobileSize * _multiplier,
      tablet: (tabletSize ?? mobileSize * 1.1) * _multiplier,
      desktop: (desktopSize ?? tabletSize ?? mobileSize * 1.2) * _multiplier,
    );

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }
}

/// Extension to easily access responsive text theme
extension ResponsiveTextThemeExtension on BuildContext {
  ResponsiveTextTheme get responsiveTextTheme => ResponsiveTextTheme(this);
}