import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/core/di/di.dart';
import 'package:flutter_clean_architecture_boilerplate/core/env/env.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/app.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/generated/locales/codegen_loader.g.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize window manager
  await windowManager.ensureInitialized();
  
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    alwaysOnTop: false,
    minimumSize: Size(600, 400),
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setPreventClose(true); // Prevent direct close
    
  });
  
  await EasyLocalization.ensureInitialized();
  await setupLocator(Env.staging(apiUrl: 'http://api.example.com'));
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}
