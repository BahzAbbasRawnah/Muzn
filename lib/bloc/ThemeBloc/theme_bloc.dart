// lib/bloc/theme/theme_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeLight()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadThemeEvent>(_onLoadTheme);
  }

  static const String _themeKey = 'isDarkTheme';

  Future<void> _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool(_themeKey) ?? false;
    if (isDarkTheme) {
      emit(ThemeDark());
    } else {
      emit(ThemeLight());
    }
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    if (state is ThemeLight) {
      emit(ThemeDark());
      prefs.setBool(_themeKey, true);
    } else {
      emit(ThemeLight());
      prefs.setBool(_themeKey, false);
    }
  }
}