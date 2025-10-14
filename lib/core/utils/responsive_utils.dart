import 'package:flutter/material.dart';

/// Enum representing different screen breakpoints
enum ScreenBreakpoint {
  mobile(0, 600),
  tablet(600, 1024),
  desktop(1024, 1440),
  largeDesktop(1440, double.infinity);

  const ScreenBreakpoint(this.min, this.max);

  final double min;
  final double max;

  /// Check if the given width falls within this breakpoint
  bool contains(double width) {
    return width >= min && width < max;
  }
}

/// Enum for device types based on screen size
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Utility class for responsive design helpers
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Common mobile breakpoint
  static const double mobileBreakpoint = 600;
  
  /// Common tablet breakpoint
  static const double tabletBreakpoint = 1024;
  
  /// Common desktop breakpoint
  static const double desktopBreakpoint = 1440;

  /// Get the current device type based on screen width
  static DeviceType getDeviceType(double width) {
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else if (width < desktopBreakpoint) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  /// Get the current screen breakpoint
  static ScreenBreakpoint getBreakpoint(double width) {
    for (final breakpoint in ScreenBreakpoint.values) {
      if (breakpoint.contains(width)) {
        return breakpoint;
      }
    }
    return ScreenBreakpoint.largeDesktop;
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Check if current screen is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  /// Get responsive horizontal padding
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64.0);
    }
  }

  /// Get responsive margin
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(8.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  /// Get responsive column count for grids
  static int getResponsiveColumnCount(BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
    int largeDesktopColumns = 4,
  }) {
    if (isMobile(context)) {
      return mobileColumns;
    } else if (isTablet(context)) {
      return tabletColumns;
    } else if (isLargeDesktop(context)) {
      return largeDesktopColumns;
    } else {
      return desktopColumns;
    }
  }

  /// Get responsive font size multiplier
  static double getResponsiveFontSizeMultiplier(BuildContext context) {
    if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /// Get responsive max width for content containers
  static double getResponsiveMaxWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isMobile(context)) {
      return screenWidth;
    } else if (isTablet(context)) {
      return screenWidth * 0.9;
    } else {
      return 1200.0; // Max content width for desktop
    }
  }

  /// Get responsive card elevation
  static double getResponsiveElevation(BuildContext context) {
    if (isMobile(context)) {
      return 2.0;
    } else if (isTablet(context)) {
      return 4.0;
    } else {
      return 8.0;
    }
  }

  /// Get responsive border radius
  static BorderRadius getResponsiveBorderRadius(BuildContext context) {
    if (isMobile(context)) {
      return BorderRadius.circular(8.0);
    } else if (isTablet(context)) {
      return BorderRadius.circular(12.0);
    } else {
      return BorderRadius.circular(16.0);
    }
  }
}