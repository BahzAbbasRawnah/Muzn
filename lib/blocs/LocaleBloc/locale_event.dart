part of 'locale_bloc.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class LoadLocaleEvent extends LocaleEvent {}

class ChangeLocaleEvent extends LocaleEvent {
  final String languageCode;

  const ChangeLocaleEvent(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}