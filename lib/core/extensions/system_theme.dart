// Helper extension for easy theme access
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/color_theme.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/system_theme.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/system_theme_data.dart';
import 'package:flutter_clean_architecture_boilerplate/presentation/theme/text_theme.dart';

extension ThemeExtension on BuildContext {
  SystemThemeData get theme => SystemTheme.of(this)!.theme;

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;
}
