import 'package:flutter/material.dart';

/// Material 3 theme configuration for the Notes app.
class AppTheme {
  AppTheme._();

  static const _seedColor = Color(0xFFFFCC02);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
      );
}
