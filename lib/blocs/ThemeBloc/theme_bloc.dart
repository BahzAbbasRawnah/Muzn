// lib/bloc/theme/theme_bloc.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadThemeEvent>(_onLoadTheme);
    on<SetSystemThemeEvent>(_onSetSystemTheme);
    
    // Load theme when bloc is created
    add(LoadThemeEvent());
  }

  static const String _themeKey = 'theme_mode';
  static const String _useSystemTheme = 'use_system_theme';

  Future<void> _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    try {
      emit(ThemeLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final useSystemTheme = prefs.getBool(_useSystemTheme) ?? true;
      
      if (useSystemTheme) {
        final isDark = SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
        emit(isDark ? ThemeDark() : ThemeLight());
        return;
      }
      
      final themeMode = prefs.getString(_themeKey) ?? 'light';
      emit(themeMode == 'dark' ? ThemeDark() : ThemeLight());
    } catch (e) {
      emit(ThemeError('Failed to load theme: ${e.toString()}'));
      // Default to light theme in case of error
      emit(ThemeLight());
    }
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Disable system theme when manually toggling
      await prefs.setBool(_useSystemTheme, false);
      
      if (state is ThemeLight) {
        await prefs.setString(_themeKey, 'dark');
        emit(ThemeDark());
      } else {
        await prefs.setString(_themeKey, 'light');
        emit(ThemeLight());
      }
    } catch (e) {
      emit(ThemeError('Failed to toggle theme: ${e.toString()}'));
      // Maintain current state in case of error
      emit(state);
    }
  }

  Future<void> _onSetSystemTheme(SetSystemThemeEvent event, Emitter<ThemeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_useSystemTheme, true);
      
      final isDark = SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
      emit(isDark ? ThemeDark() : ThemeLight());
    } catch (e) {
      emit(ThemeError('Failed to set system theme: ${e.toString()}'));
      // Maintain current state in case of error
      emit(state);
    }
  }

  // Helper method to check if system theme is being used
  Future<bool> isUsingSystemTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_useSystemTheme) ?? true;
    } catch (e) {
      return true; // Default to system theme if there's an error
    }
  }
}