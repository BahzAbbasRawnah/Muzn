part of 'locale_bloc.dart';

abstract class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object> get props => [];
}

class LocaleInitial extends LocaleState {}

class LocaleLoading extends LocaleState {}

class LocaleLoadedState extends LocaleState {
  final Locale locale;

  const LocaleLoadedState(this.locale);

  @override
  List<Object> get props => [locale];
}

class LocaleError extends LocaleState {
  final String message;

  const LocaleError(this.message);

  @override
  List<Object> get props => [message];
}