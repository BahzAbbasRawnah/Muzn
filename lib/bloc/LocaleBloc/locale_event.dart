part of 'locale_bloc.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class ChangeLocaleEvent extends LocaleEvent {
  final String languageCode;

  const ChangeLocaleEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LoadLocaleEvent extends LocaleEvent {}