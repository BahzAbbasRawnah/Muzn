import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const String _localeKey = 'locale';

  LocaleBloc() : super(const LocaleLoadedState(Locale('en'))) {
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<LoadLocaleEvent>(_onLoadLocale);
  }

  Future<void> _onChangeLocale(ChangeLocaleEvent event, Emitter<LocaleState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, event.languageCode);
    emit(LocaleLoadedState(Locale(event.languageCode)));
  }

  Future<void> _onLoadLocale(LoadLocaleEvent event, Emitter<LocaleState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'ar';
    emit(LocaleLoadedState(Locale(languageCode)));
  }
}