import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/core/extensions/responsive_extension.dart';

/// A responsive spacing system that adapts to screen sizes
class ResponsiveSpacing {
  ResponsiveSpacing._();

  /// Base spacing values that scale with screen size
  static double xs(BuildContext context) => context.responsiveSpacing(mobile: 4.0);
  static double sm(BuildContext context) => context.responsiveSpacing(mobile: 8.0);
  static double md(BuildContext context) => context.responsiveSpacing(mobile: 16.0);
  static double lg(BuildContext context) => context.responsiveSpacing(mobile: 24.0);
  static double xl(BuildContext context) => context.responsiveSpacing(mobile: 32.0);
  static double xxl(BuildContext context) => context.responsiveSpacing(mobile: 48.0);
  static double xxxl(BuildContext context) => context.responsiveSpacing(mobile: 64.0);

  /// Responsive SizedBox widgets for vertical spacing
  static Widget verticalXS(BuildContext context) => SizedBox(height: xs(context));
  static Widget verticalSM(BuildContext context) => SizedBox(height: sm(context));
  static Widget verticalMD(BuildContext context) => SizedBox(height: md(context));
  static Widget verticalLG(BuildContext context) => SizedBox(height: lg(context));
  static Widget verticalXL(BuildContext context) => SizedBox(height: xl(context));
  static Widget verticalXXL(BuildContext context) => SizedBox(height: xxl(context));
  static Widget verticalXXXL(BuildContext context) => SizedBox(height: xxxl(context));

  /// Responsive SizedBox widgets for horizontal spacing
  static Widget horizontalXS(BuildContext context) => SizedBox(width: xs(context));
  static Widget horizontalSM(BuildContext context) => SizedBox(width: sm(context));
  static Widget horizontalMD(BuildContext context) => SizedBox(width: md(context));
  static Widget horizontalLG(BuildContext context) => SizedBox(width: lg(context));
  static Widget horizontalXL(BuildContext context) => SizedBox(width: xl(context));
  static Widget horizontalXXL(BuildContext context) => SizedBox(width: xxl(context));
  static Widget horizontalXXXL(BuildContext context) => SizedBox(width: xxxl(context));

  /// Responsive padding
  static EdgeInsets paddingXS(BuildContext context) => EdgeInsets.all(xs(context));
  static EdgeInsets paddingSM(BuildContext context) => EdgeInsets.all(sm(context));
  static EdgeInsets paddingMD(BuildContext context) => EdgeInsets.all(md(context));
  static EdgeInsets paddingLG(BuildContext context) => EdgeInsets.all(lg(context));
  static EdgeInsets paddingXL(BuildContext context) => EdgeInsets.all(xl(context));
  static EdgeInsets paddingXXL(BuildContext context) => EdgeInsets.all(xxl(context));
  static EdgeInsets paddingXXXL(BuildContext context) => EdgeInsets.all(xxxl(context));

  /// Responsive horizontal padding
  static EdgeInsets horizontalPaddingXS(BuildContext context) => 
      EdgeInsets.symmetric(horizontal: xs(context));
  static EdgeInsets horizontalPaddingSM(BuildContext context) => 
      EdgeInsets.symmetric(horizontal: sm(context));
  static EdgeInsets horizontalPaddingMD(BuildContext context) => 
      EdgeInsets.symmetric(horizontal: md(context));
  static EdgeInsets horizontalPaddingLG(BuildContext context) => 
      EdgeInsets.symmetric(horizontal: lg(context));
  static EdgeInsets horizontalPaddingXL(BuildContext context) => 
      EdgeInsets.symmetric(horizontal: xl(context));
  static EdgeInsets horizontalPaddingXXL(BuildContext context) => 
      EdgeInsets.symmetric(horizontal: xxl(context));
  static EdgeInsets horizontalPaddingXXXL(BuildContext context) => 
      EdgeInsets.symmetric(horizontal: xxxl(context));

  /// Responsive vertical padding
  static EdgeInsets verticalPaddingXS(BuildContext context) => 
      EdgeInsets.symmetric(vertical: xs(context));
  static EdgeInsets verticalPaddingSM(BuildContext context) => 
      EdgeInsets.symmetric(vertical: sm(context));
  static EdgeInsets verticalPaddingMD(BuildContext context) => 
      EdgeInsets.symmetric(vertical: md(context));
  static EdgeInsets verticalPaddingLG(BuildContext context) => 
      EdgeInsets.symmetric(vertical: lg(context));
  static EdgeInsets verticalPaddingXL(BuildContext context) => 
      EdgeInsets.symmetric(vertical: xl(context));
  static EdgeInsets verticalPaddingXXL(BuildContext context) => 
      EdgeInsets.symmetric(vertical: xxl(context));
  static EdgeInsets verticalPaddingXXXL(BuildContext context) => 
      EdgeInsets.symmetric(vertical: xxxl(context));

  /// Custom responsive spacing
  static double custom(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return context.responsiveValue(
      mobile: mobile,
      tablet: tablet ?? mobile * 1.25,
      desktop: desktop ?? mobile * 1.5,
      largeDesktop: largeDesktop ?? mobile * 1.75,
    );
  }
}

/// Extension for easy access to responsive spacing
extension ResponsiveSpacingExtension on BuildContext {
  /// Spacing values
  double get spaceXS => ResponsiveSpacing.xs(this);
  double get spaceSM => ResponsiveSpacing.sm(this);
  double get spaceMD => ResponsiveSpacing.md(this);
  double get spaceLG => ResponsiveSpacing.lg(this);
  double get spaceXL => ResponsiveSpacing.xl(this);
  double get spaceXXL => ResponsiveSpacing.xxl(this);
  double get spaceXXXL => ResponsiveSpacing.xxxl(this);

  /// Vertical spacing widgets
  Widget get verticalSpaceXS => ResponsiveSpacing.verticalXS(this);
  Widget get verticalSpaceSM => ResponsiveSpacing.verticalSM(this);
  Widget get verticalSpaceMD => ResponsiveSpacing.verticalMD(this);
  Widget get verticalSpaceLG => ResponsiveSpacing.verticalLG(this);
  Widget get verticalSpaceXL => ResponsiveSpacing.verticalXL(this);
  Widget get verticalSpaceXXL => ResponsiveSpacing.verticalXXL(this);
  Widget get verticalSpaceXXXL => ResponsiveSpacing.verticalXXXL(this);

  /// Horizontal spacing widgets
  Widget get horizontalSpaceXS => ResponsiveSpacing.horizontalXS(this);
  Widget get horizontalSpaceSM => ResponsiveSpacing.horizontalSM(this);
  Widget get horizontalSpaceMD => ResponsiveSpacing.horizontalMD(this);
  Widget get horizontalSpaceLG => ResponsiveSpacing.horizontalLG(this);
  Widget get horizontalSpaceXL => ResponsiveSpacing.horizontalXL(this);
  Widget get horizontalSpaceXXL => ResponsiveSpacing.horizontalXXL(this);
  Widget get horizontalSpaceXXXL => ResponsiveSpacing.horizontalXXXL(this);

  /// Padding
  EdgeInsets get paddingXS => ResponsiveSpacing.paddingXS(this);
  EdgeInsets get paddingSM => ResponsiveSpacing.paddingSM(this);
  EdgeInsets get paddingMD => ResponsiveSpacing.paddingMD(this);
  EdgeInsets get paddingLG => ResponsiveSpacing.paddingLG(this);
  EdgeInsets get paddingXL => ResponsiveSpacing.paddingXL(this);
  EdgeInsets get paddingXXL => ResponsiveSpacing.paddingXXL(this);
  EdgeInsets get paddingXXXL => ResponsiveSpacing.paddingXXXL(this);

  /// Horizontal padding
  EdgeInsets get horizontalPaddingXS => ResponsiveSpacing.horizontalPaddingXS(this);
  EdgeInsets get horizontalPaddingSM => ResponsiveSpacing.horizontalPaddingSM(this);
  EdgeInsets get horizontalPaddingMD => ResponsiveSpacing.horizontalPaddingMD(this);
  EdgeInsets get horizontalPaddingLG => ResponsiveSpacing.horizontalPaddingLG(this);
  EdgeInsets get horizontalPaddingXL => ResponsiveSpacing.horizontalPaddingXL(this);
  EdgeInsets get horizontalPaddingXXL => ResponsiveSpacing.horizontalPaddingXXL(this);
  EdgeInsets get horizontalPaddingXXXL => ResponsiveSpacing.horizontalPaddingXXXL(this);

  /// Vertical padding
  EdgeInsets get verticalPaddingXS => ResponsiveSpacing.verticalPaddingXS(this);
  EdgeInsets get verticalPaddingSM => ResponsiveSpacing.verticalPaddingSM(this);
  EdgeInsets get verticalPaddingMD => ResponsiveSpacing.verticalPaddingMD(this);
  EdgeInsets get verticalPaddingLG => ResponsiveSpacing.verticalPaddingLG(this);
  EdgeInsets get verticalPaddingXL => ResponsiveSpacing.verticalPaddingXL(this);
  EdgeInsets get verticalPaddingXXL => ResponsiveSpacing.verticalPaddingXXL(this);
  EdgeInsets get verticalPaddingXXXL => ResponsiveSpacing.verticalPaddingXXXL(this);
}