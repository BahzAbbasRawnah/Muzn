import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const String _localeKey = 'locale';
  
  // Supported locales
  static const Map<String, String> supportedLocales = {
    'ar': 'العربية',
    'en': 'English',
    'ur': 'اردو',
    'hi': 'हिंदी',
  };

  LocaleBloc() : super(LocaleInitial()) {
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<LoadLocaleEvent>(_onLoadLocale);
    
    // Load locale when bloc is created
    add(LoadLocaleEvent());
  }

  Future<void> _onChangeLocale(ChangeLocaleEvent event, Emitter<LocaleState> emit) async {
    try {
      emit(LocaleLoading());
      
      if (!supportedLocales.containsKey(event.languageCode)) {
        emit(LocaleError('Unsupported language code: ${event.languageCode}'));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, event.languageCode);
      emit(LocaleLoadedState(Locale(event.languageCode)));
    } catch (e) {
      emit(LocaleError('Failed to change locale: ${e.toString()}'));
      // Keep current state in case of error
      if (state is LocaleLoadedState) {
        emit(state);
      } else {
        // Default to Arabic if no current state
        emit(const LocaleLoadedState(Locale('ar')));
      }
    }
  }

  Future<void> _onLoadLocale(LoadLocaleEvent event, Emitter<LocaleState> emit) async {
    try {
      emit(LocaleLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey) ?? 'ar';
      
      if (!supportedLocales.containsKey(languageCode)) {
        // If saved locale is no longer supported, default to Arabic
        await prefs.setString(_localeKey, 'ar');
        emit(const LocaleLoadedState(Locale('ar')));
        return;
      }

      emit(LocaleLoadedState(Locale(languageCode)));
    } catch (e) {
      emit(LocaleError('Failed to load locale: ${e.toString()}'));
      // Default to Arabic in case of error
      emit(const LocaleLoadedState(Locale('ar')));
    }
  }

  // Helper method to get current locale code
  String getCurrentLocale() {
    if (state is LocaleLoadedState) {
      return (state as LocaleLoadedState).locale.languageCode;
    }
    return 'ar'; // Default to Arabic
  }

  // Helper method to get list of supported locales
  static List<Locale> getSupportedLocales() {
    return supportedLocales.keys.map((code) => Locale(code)).toList();
  }

  // Helper method to get language name from code
  static String getLanguageName(String code) {
    return supportedLocales[code] ?? code;
  }
}