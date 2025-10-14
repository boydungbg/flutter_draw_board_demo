import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/routes/routes.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/system_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SystemTheme(
      themeMode: ThemeMode.light,
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
