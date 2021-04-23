import 'package:flutter/material.dart';

class Themes {
  static ThemeData LightTheme() {
    return ThemeData(
      brightness: Brightness.light,
    );
  }

  static ThemeData DarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
    );
  }

  static ThemeMode Theme() {
    return ThemeMode.system;
  }
}

// ignore_for_file: non_constant_identifier_names