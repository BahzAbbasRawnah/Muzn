part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ToggleThemeEvent extends ThemeEvent {}

class LoadThemeEvent extends ThemeEvent {}

class SetSystemThemeEvent extends ThemeEvent {}
