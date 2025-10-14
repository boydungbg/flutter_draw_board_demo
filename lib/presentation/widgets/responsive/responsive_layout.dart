import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/core/extensions/responsive_extension.dart';

/// A layout helper that provides common responsive layout patterns
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.child,
    this.enableSidePadding = true,
    this.enableTopPadding = true,
    this.enableBottomPadding = true,
    this.customPadding,
  });

  final Widget child;
  final bool enableSidePadding;
  final bool enableTopPadding;
  final bool enableBottomPadding;
  final EdgeInsets? customPadding;

  @override
  Widget build(BuildContext context) {
    if (customPadding != null) {
      return Padding(
        padding: customPadding!,
        child: child,
      );
    }

    double left = 0, right = 0, top = 0, bottom = 0;

    if (enableSidePadding) {
      final horizontalPadding = context.responsiveHorizontalPadding;
      left = horizontalPadding.left;
      right = horizontalPadding.right;
    }

    if (enableTopPadding || enableBottomPadding) {
      final verticalPadding = context.responsiveValue(
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      );

      if (enableTopPadding) top = verticalPadding;
      if (enableBottomPadding) bottom = verticalPadding;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child,
    );
  }
}

/// A responsive two-panel layout (sidebar + main content)
class ResponsiveTwoPanel extends StatelessWidget {
  const ResponsiveTwoPanel({
    super.key,
    required this.sidebar,
    required this.mainContent,
    this.sidebarWidth = 300.0,
    this.showSidebarOnTablet = true,
    this.sidebarBreakpoint,
  });

  final Widget sidebar;
  final Widget mainContent;
  final double sidebarWidth;
  final bool showSidebarOnTablet;
  final double? sidebarBreakpoint;

  @override
  Widget build(BuildContext context) {
    final breakpoint = sidebarBreakpoint ?? 
        (showSidebarOnTablet ? 600.0 : 1024.0);

    if (context.screenWidth >= breakpoint) {
      return Row(
        children: [
          SizedBox(
            width: sidebarWidth,
            child: sidebar,
          ),
          Expanded(child: mainContent),
        ],
      );
    }

    return mainContent;
  }
}

/// A responsive three-panel layout (sidebar + main + aside)
class ResponsiveThreePanel extends StatelessWidget {
  const ResponsiveThreePanel({
    super.key,
    required this.sidebar,
    required this.mainContent,
    required this.aside,
    this.sidebarWidth = 250.0,
    this.asideWidth = 300.0,
    this.showSidebarBreakpoint = 768.0,
    this.showAsideBreakpoint = 1200.0,
  });

  final Widget sidebar;
  final Widget mainContent;
  final Widget aside;
  final double sidebarWidth;
  final double asideWidth;
  final double showSidebarBreakpoint;
  final double showAsideBreakpoint;

  @override
  Widget build(BuildContext context) {
    final showSidebar = context.screenWidth >= showSidebarBreakpoint;
    final showAside = context.screenWidth >= showAsideBreakpoint;

    return Row(
      children: [
        if (showSidebar)
          SizedBox(
            width: sidebarWidth,
            child: sidebar,
          ),
        Expanded(child: mainContent),
        if (showAside)
          SizedBox(
            width: asideWidth,
            child: aside,
          ),
      ],
    );
  }
}

/// A responsive master-detail layout
class ResponsiveMasterDetail extends StatelessWidget {
  const ResponsiveMasterDetail({
    super.key,
    required this.master,
    required this.detail,
    this.masterWidth = 400.0,
    this.breakpoint = 768.0,
    this.showDetailOnMobile = false,
  });

  final Widget master;
  final Widget detail;
  final double masterWidth;
  final double breakpoint;
  final bool showDetailOnMobile;

  @override
  Widget build(BuildContext context) {
    if (context.screenWidth >= breakpoint) {
      return Row(
        children: [
          SizedBox(
            width: masterWidth,
            child: master,
          ),
          Expanded(child: detail),
        ],
      );
    }

    // On smaller screens, show either master or detail
    return showDetailOnMobile ? detail : master;
  }
}

/// A responsive scaffold that adapts navigation patterns
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.navigationItems,
    this.onNavigationChanged,
    this.currentIndex = 0,
    this.showNavigationRail = true,
    this.railBreakpoint = 768.0,
    this.extendedRailBreakpoint = 1200.0,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final List<NavigationItem>? navigationItems;
  final ValueChanged<int>? onNavigationChanged;
  final int currentIndex;
  final bool showNavigationRail;
  final double railBreakpoint;
  final double extendedRailBreakpoint;

  @override
  Widget build(BuildContext context) {
    if (navigationItems == null || !showNavigationRail) {
      return Scaffold(
        appBar: appBar,
        body: body,
        drawer: drawer,
        endDrawer: endDrawer,
      );
    }

    if (context.screenWidth >= railBreakpoint) {
      final extended = context.screenWidth >= extendedRailBreakpoint;
      
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              extended: extended,
              destinations: navigationItems!
                  .map((item) => NavigationRailDestination(
                        icon: item.icon,
                        selectedIcon: item.selectedIcon ?? item.icon,
                        label: Text(item.label),
                      ))
                  .toList(),
              selectedIndex: currentIndex,
              onDestinationSelected: onNavigationChanged,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
        endDrawer: endDrawer,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNavigationChanged,
        type: BottomNavigationBarType.fixed,
        items: navigationItems!
            .map((item) => BottomNavigationBarItem(
                  icon: item.icon,
                  activeIcon: item.selectedIcon ?? item.icon,
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

/// Data class for navigation items
class NavigationItem {
  const NavigationItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
}