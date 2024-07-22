import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/colors_theme.dart';
import '../theme/style_theme.dart';

final themeProvider = Provider<ThemeProvider>((_) => ThemeProvider());

class ThemeProvider {
  final ThemeData theme = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: colorScheme,
    appBarTheme: appBarTheme,
    iconTheme: iconThemeData,
    dividerTheme: const DividerThemeData(color: Color(0XFFEAEEF2)),
  );
}
