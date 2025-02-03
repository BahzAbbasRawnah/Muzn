import 'package:equatable/equatable.dart';
import 'package:muzn/models/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserAuthenticated extends UserState {
  final User user;

  UserAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUnauthenticated extends UserState {}

class UserRegistered extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserProfileUpdated extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;

  UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserDeleted extends UserState {}