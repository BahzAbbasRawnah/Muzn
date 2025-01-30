part of 'locale_bloc.dart';

abstract class LocaleState extends Equatable {
  final Locale locale;

  const LocaleState(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LocaleLoadedState extends LocaleState {
  const LocaleLoadedState(Locale locale) : super(locale);
}