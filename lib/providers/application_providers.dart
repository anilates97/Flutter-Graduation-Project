import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changeThemeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(changeThemeProvider);
  return themeMode == ThemeMode.dark;
});
