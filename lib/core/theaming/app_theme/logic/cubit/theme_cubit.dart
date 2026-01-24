import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme State
class ThemeState {
  final ThemeMode themeMode;
  final bool isDarkMode;

  ThemeState({
    required this.themeMode,
    required this.isDarkMode,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

// Theme Cubit
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit()
      : super(ThemeState(
          themeMode: ThemeMode.light,
          isDarkMode: false,
        )) {
    _loadThemePreference();
  }

  // Load theme preference from storage
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      
      emit(ThemeState(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        isDarkMode: isDark,
      ));
    } catch (e) {
      // If there's an error, use default light theme
      print('Error loading theme preference: $e');
    }
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    final newIsDarkMode = !state.isDarkMode;
    
    emit(ThemeState(
      themeMode: newIsDarkMode ? ThemeMode.dark : ThemeMode.light,
      isDarkMode: newIsDarkMode,
    ));

    // Save preference
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, newIsDarkMode);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  // Set specific theme mode
  Future<void> setThemeMode(bool isDark) async {
    emit(ThemeState(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      isDarkMode: isDark,
    ));

    // Save preference
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }
}
