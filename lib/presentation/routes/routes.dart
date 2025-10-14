import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/home/home_screen.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/home/responsive_navigation_demo.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/routes/route_name.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: RouteName.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: RouteName.navigationDemo,
        builder: (BuildContext context, GoRouterState state) {
          return const ResponsiveNavigationDemo();
        },
      ),
    ],
  );
}
