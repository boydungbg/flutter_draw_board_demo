import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/core/extensions/responsive_extension.dart';

/// A widget that builds different layouts based on screen breakpoints
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  /// Widget to display on mobile devices
  final Widget mobile;

  /// Widget to display on tablet devices (defaults to mobile if not provided)
  final Widget? tablet;

  /// Widget to display on desktop devices (defaults to tablet or mobile if not provided)
  final Widget? desktop;

  /// Widget to display on large desktop devices (defaults to desktop, tablet, or mobile if not provided)
  final Widget? largeDesktop;

  @override
  Widget build(BuildContext context) {
    return context.responsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }
}

/// A widget that wraps content with responsive constraints
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: margin ?? context.responsiveMargin,
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? context.responsiveMaxWidth,
        ),
        child: Container(
          padding: padding ?? context.responsivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// A responsive grid widget
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.largeDesktopColumns = 4,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.childAspectRatio = 1.0,
    this.physics,
    this.shrinkWrap = false,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int largeDesktopColumns;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final columnCount = context.responsiveColumnCount(
      mobileColumns: mobileColumns,
      tabletColumns: tabletColumns,
      desktopColumns: desktopColumns,
      largeDesktopColumns: largeDesktopColumns,
    );

    return GridView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A responsive row that can stack vertically on smaller screens
class ResponsiveRow extends StatelessWidget {
  const ResponsiveRow({
    super.key,
    required this.children,
    this.stackOnMobile = true,
    this.stackOnTablet = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 16.0,
  });

  final List<Widget> children;
  final bool stackOnMobile;
  final bool stackOnTablet;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final shouldStack = (context.isMobile && stackOnMobile) ||
        (context.isTablet && stackOnTablet);

    if (shouldStack) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children
            .map((child) => Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: child,
                ))
            .toList(),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children
          .map((child) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: spacing),
                  child: child,
                ),
              ))
          .toList(),
    );
  }
}

/// A responsive card widget with adaptive sizing
class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({
    super.key,
    required this.child,
    this.color,
    this.elevation,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final Color? color;
  final double? elevation;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation ?? context.responsiveElevation,
      margin: margin ?? context.responsiveMargin,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? context.responsiveBorderRadius,
      ),
      child: Padding(
        padding: padding ?? context.responsivePadding,
        child: child,
      ),
    );
  }
}

/// A widget that shows different content based on orientation
class ResponsiveOrientation extends StatelessWidget {
  const ResponsiveOrientation({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  final Widget portrait;
  final Widget landscape;

  @override
  Widget build(BuildContext context) {
    return context.isLandscape ? landscape : portrait;
  }
}

/// A responsive app bar that adapts its height and content
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = context.responsiveValue(
      mobile: kToolbarHeight,
      tablet: kToolbarHeight + 8,
      desktop: kToolbarHeight + 16,
    );

    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? context.responsiveElevation,
      toolbarHeight: responsiveHeight,
    );
  }

  @override
  Size get preferredSize {
    // This will be updated when the widget is built in context
    return const Size.fromHeight(kToolbarHeight);
  }
}