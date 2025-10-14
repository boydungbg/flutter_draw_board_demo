import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/widgets/responsive/index.dart';
import 'package:flutter_clean_architecture_boilerplate/core/extensions/index.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/responsive_spacing.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/responsive_text_theme.dart';

class ResponsiveNavigationDemo extends StatefulWidget {
  const ResponsiveNavigationDemo({super.key});

  @override
  State<ResponsiveNavigationDemo> createState() => _ResponsiveNavigationDemoState();
}

class _ResponsiveNavigationDemoState extends State<ResponsiveNavigationDemo> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      icon: Icon(Icons.home),
      selectedIcon: Icon(Icons.home_filled),
      label: 'Home',
    ),
    NavigationItem(
      icon: Icon(Icons.explore),
      selectedIcon: Icon(Icons.explore),
      label: 'Explore',
    ),
    NavigationItem(
      icon: Icon(Icons.notifications),
      selectedIcon: Icon(Icons.notifications),
      label: 'Notifications',
    ),
    NavigationItem(
      icon: Icon(Icons.person),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
    NavigationItem(
      icon: Icon(Icons.settings),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(_navigationItems[_currentIndex].label),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      navigationItems: _navigationItems,
      currentIndex: _currentIndex,
      onNavigationChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      body: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    return ResponsiveContainer(
      child: ResponsiveLayout(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageHeader(),
              context.verticalSpaceLG,
              _buildPageContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _navigationItems[_currentIndex].selectedIcon ?? _navigationItems[_currentIndex].icon,
              context.horizontalSpaceMD,
              Expanded(
                child: Text(
                  '${_navigationItems[_currentIndex].label} Page',
                  style: context.responsiveTextTheme.responsiveHeadline,
                ),
              ),
            ],
          ),
          context.verticalSpaceMD,
          Text(
            'This is a responsive navigation demo. The navigation adapts based on screen size:',
            style: context.responsiveTextTheme.bodyLarge,
          ),
          context.verticalSpaceSM,
          _buildNavigationInfo(),
        ],
      ),
    );
  }

  Widget _buildNavigationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Mobile (< 768px)', 'Bottom Navigation Bar'),
        _buildInfoRow('Tablet (768px - 1200px)', 'Navigation Rail'),
        _buildInfoRow('Desktop (> 1200px)', 'Extended Navigation Rail'),
      ],
    );
  }

  Widget _buildInfoRow(String breakpoint, String navigation) {
    return Padding(
      padding: context.verticalPaddingXS,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          context.horizontalSpaceSM,
          Expanded(
            child: RichText(
              text: TextSpan(
                style: context.responsiveTextTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$breakpoint: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: navigation),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildContentCard('Current Device', _getCurrentDeviceInfo()),
        _buildContentCard('Screen Size', '${context.screenWidth.toInt()} x ${context.screenHeight.toInt()}'),
        _buildContentCard('Breakpoint', context.breakpoint.name),
        _buildContentCard('Navigation Type', _getNavigationType()),
        _buildContentCard('Orientation', context.isLandscape ? 'Landscape' : 'Portrait'),
        _buildContentCard('Text Scale', context.isLargeTextScale ? 'Large' : 'Normal'),
      ],
    );
  }

  Widget _buildContentCard(String title, String content) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.responsiveTextTheme.titleMedium,
          ),
          context.verticalSpaceSM,
          Text(
            content,
            style: context.responsiveTextTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  String _getCurrentDeviceInfo() {
    if (context.isMobile) return 'Mobile Device';
    if (context.isTablet) return 'Tablet Device';
    if (context.isLargeDesktop) return 'Large Desktop';
    return 'Desktop';
  }

  String _getNavigationType() {
    if (context.screenWidth < 768) return 'Bottom Navigation';
    if (context.screenWidth < 1200) return 'Navigation Rail';
    return 'Extended Navigation Rail';
  }
}