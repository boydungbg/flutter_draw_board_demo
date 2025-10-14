import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/core/utils/responsive_utils.dart';

/// Extension methods on BuildContext for easy access to responsive utilities
extension ResponsiveExtension on BuildContext {
  /// Get the screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get the screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get the screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get the current device type
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(screenWidth);

  /// Get the current screen breakpoint
  ScreenBreakpoint get breakpoint => ResponsiveUtils.getBreakpoint(screenWidth);

  /// Check if current screen is mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Check if current screen is tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Check if current screen is desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Check if current screen is large desktop
  bool get isLargeDesktop => ResponsiveUtils.isLargeDesktop(this);

  /// Get responsive padding
  EdgeInsets get responsivePadding => ResponsiveUtils.getResponsivePadding(this);

  /// Get responsive horizontal padding
  EdgeInsets get responsiveHorizontalPadding =>
      ResponsiveUtils.getResponsiveHorizontalPadding(this);

  /// Get responsive margin
  EdgeInsets get responsiveMargin => ResponsiveUtils.getResponsiveMargin(this);

  /// Get responsive font size multiplier
  double get responsiveFontSizeMultiplier =>
      ResponsiveUtils.getResponsiveFontSizeMultiplier(this);

  /// Get responsive max width
  double get responsiveMaxWidth => ResponsiveUtils.getResponsiveMaxWidth(this);

  /// Get responsive elevation
  double get responsiveElevation => ResponsiveUtils.getResponsiveElevation(this);

  /// Get responsive border radius
  BorderRadius get responsiveBorderRadius =>
      ResponsiveUtils.getResponsiveBorderRadius(this);

  /// Get responsive column count
  int responsiveColumnCount({
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
    int largeDesktopColumns = 4,
  }) =>
      ResponsiveUtils.getResponsiveColumnCount(
        this,
        mobileColumns: mobileColumns,
        tabletColumns: tabletColumns,
        desktopColumns: desktopColumns,
        largeDesktopColumns: largeDesktopColumns,
      );

  /// Get value based on current breakpoint
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive spacing
  double responsiveSpacing({
    double mobile = 8.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveValue(
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? mobile * 2,
      largeDesktop: largeDesktop ?? mobile * 2.5,
    );
  }

  /// Get responsive font size
  double responsiveFontSize(double baseFontSize) {
    return baseFontSize * responsiveFontSizeMultiplier;
  }

  /// Check if device is in landscape mode
  bool get isLandscape => screenWidth > screenHeight;

  /// Check if device is in portrait mode
  bool get isPortrait => screenHeight > screenWidth;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Get view insets (keyboard height, etc.)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Get device pixel ratio
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Check if text scale factor is large (accessibility)
  bool get isLargeTextScale => MediaQuery.of(this).textScaler.scale(1.0) > 1.3;
}