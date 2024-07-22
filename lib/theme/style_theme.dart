import 'package:flutter/material.dart';

import 'colors_theme.dart';

const appBarTheme = AppBarTheme(
  backgroundColor: secondary,
  centerTitle: true,
  titleTextStyle: TextStyle(
    color: onPrimary,
  ),
  iconTheme: iconThemeData,
  elevation: 0,
);

const iconThemeData = IconThemeData(color: onPrimary);
