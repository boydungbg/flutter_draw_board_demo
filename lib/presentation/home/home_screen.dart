import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/widgets/responsive/index.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/widgets/whiteboard/advanced_whiteboard_widget.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WindowListener {
  bool isOverlayMode = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isOverlayMode
          ? null
          : ResponsiveAppBar(
              title: const Text('White Board Demo'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
      backgroundColor: isOverlayMode ? Colors.transparent : null,
      body: WhiteboardWidget(
        onOverlayModeChanged: (overlayMode) async {
          setState(() {
            isOverlayMode = overlayMode;
          });

          if (overlayMode) {
            // Enter overlay mode - make window transparent and hide title bar
            await windowManager.setOpacity(0.95);
            await windowManager.setAlwaysOnTop(true);
            await windowManager.setIgnoreMouseEvents(false);
            await windowManager.setBackgroundColor(Colors.transparent);
            await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
            await windowManager.maximize();
            await windowManager.setAsFrameless();
          } else {
            // Exit overlay mode - restore normal window with title bar
            await windowManager.setOpacity(1.0);
            await windowManager.setAlwaysOnTop(false);
            await windowManager.setIgnoreMouseEvents(false);
            await windowManager.setBackgroundColor(Colors.white);
            await windowManager.setTitleBarStyle(TitleBarStyle.normal);
            // Remove frameless mode to restore title bar
            WindowOptions windowOptions = const WindowOptions(
              titleBarStyle: TitleBarStyle.normal,
            );
            await windowManager.waitUntilReadyToShow(windowOptions);
          }
        },
      ),
    );
  }
}
