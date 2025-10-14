import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/core/extensions/index.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/responsive_text_theme.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/responsive_spacing.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/widgets/responsive/index.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/routes/route_name.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(
        title: Text(
          'Flutter Clean Architecture',
          style: context.responsiveTextTheme.responsiveTitle,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ResponsiveContainer(
        child: ResponsiveLayout(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero section
                _buildHeroSection(context),
                
                context.verticalSpaceLG,
                
                // Features grid
                _buildFeaturesSection(context),
                
                context.verticalSpaceLG,
                
                // Info cards
                _buildInfoCardsSection(context),
                
                context.verticalSpaceXL,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Responsive Design!',
            style: context.responsiveTextTheme.responsiveDisplayLarge,
          ),
          context.verticalSpaceMD,
          Text(
            'This Flutter app demonstrates responsive design principles with clean architecture. '
            'Resize your window or try different devices to see how the layout adapts.',
            style: context.responsiveTextTheme.responsiveBody,
          ),
          context.verticalSpaceLG,
          ResponsiveRow(
            stackOnMobile: true,
            children: [
              ElevatedButton(
                onPressed: () => context.go(RouteName.navigationDemo),
                child: Padding(
                  padding: context.paddingSM,
                  child: Text(
                    'Navigation Demo',
                    style: context.responsiveTextTheme.labelLarge,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Padding(
                  padding: context.paddingSM,
                  child: Text(
                    'Learn More',
                    style: context.responsiveTextTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: context.responsiveTextTheme.responsiveHeadline,
        ),
        context.verticalSpaceMD,
        ResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 3,
          largeDesktopColumns: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildFeatureCard(
              context,
              icon: Icons.devices,
              title: 'Responsive Design',
              description: 'Adapts to any screen size automatically',
            ),
            _buildFeatureCard(
              context,
              icon: Icons.architecture,
              title: 'Clean Architecture',
              description: 'Well-structured and maintainable code',
            ),
            _buildFeatureCard(
              context,
              icon: Icons.phone_android,
              title: 'Mobile First',
              description: 'Optimized for mobile devices',
            ),
            _buildFeatureCard(
              context,
              icon: Icons.desktop_windows,
              title: 'Desktop Ready',
              description: 'Scales beautifully to desktop',
            ),
            _buildFeatureCard(
              context,
              icon: Icons.tablet,
              title: 'Tablet Optimized',
              description: 'Perfect tablet experience',
            ),
            _buildFeatureCard(
              context,
              icon: Icons.accessibility,
              title: 'Accessible',
              description: 'Built with accessibility in mind',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: context.responsiveValue(
              mobile: 32.0,
              tablet: 40.0,
              desktop: 48.0,
            ),
            color: Theme.of(context).primaryColor,
          ),
          context.verticalSpaceMD,
          Text(
            title,
            style: context.responsiveTextTheme.titleMedium,
          ),
          context.verticalSpaceSM,
          Text(
            description,
            style: context.responsiveTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCardsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Information',
          style: context.responsiveTextTheme.responsiveHeadline,
        ),
        context.verticalSpaceMD,
        ResponsiveBuilder(
          mobile: _buildDeviceInfoMobile(context),
          tablet: _buildDeviceInfoTablet(context),
          desktop: _buildDeviceInfoDesktop(context),
        ),
      ],
    );
  }

  Widget _buildDeviceInfoMobile(BuildContext context) {
    return Column(
      children: [
        _buildInfoCard(context, 'Device Type', 'Mobile'),
        context.verticalSpaceSM,
        _buildInfoCard(context, 'Screen Width', '${context.screenWidth.toInt()}px'),
        context.verticalSpaceSM,
        _buildInfoCard(context, 'Breakpoint', context.breakpoint.name),
      ],
    );
  }

  Widget _buildDeviceInfoTablet(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildInfoCard(context, 'Device Type', 'Tablet')),
        context.horizontalSpaceSM,
        Expanded(child: _buildInfoCard(context, 'Screen Width', '${context.screenWidth.toInt()}px')),
        context.horizontalSpaceSM,
        Expanded(child: _buildInfoCard(context, 'Breakpoint', context.breakpoint.name)),
      ],
    );
  }

  Widget _buildDeviceInfoDesktop(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildInfoCard(context, 'Device Type', 'Desktop')),
        context.horizontalSpaceMD,
        Expanded(child: _buildInfoCard(context, 'Screen Width', '${context.screenWidth.toInt()}px')),
        context.horizontalSpaceMD,
        Expanded(child: _buildInfoCard(context, 'Breakpoint', context.breakpoint.name)),
        context.horizontalSpaceMD,
        Expanded(child: _buildInfoCard(context, 'Orientation', context.isLandscape ? 'Landscape' : 'Portrait')),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.responsiveTextTheme.labelMedium.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          context.verticalSpaceXS,
          Text(
            value,
            style: context.responsiveTextTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
