import 'package:flutter/material.dart';

class ThemeService {
  ThemeService._private();
  static final ThemeService instance = ThemeService._private();

  // default dark
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);

  void toggle() {
    themeMode.value = (themeMode.value == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
  }
}
