import 'package:flutter/material.dart';

class AppTheme {
  static const _brandRed = Color(0xFFE53935);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(seedColor: _brandRed, brightness: Brightness.light);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: false),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      cardTheme: const CardTheme(margin: EdgeInsets.symmetric(vertical: 8)),
    );
  }
}
