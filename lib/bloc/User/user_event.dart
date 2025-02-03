import 'package:muzn/models/user_model.dart';


abstract class UserEvent {}

class RegisterEvent extends UserEvent {
  final User user;

  RegisterEvent(this.user);
}

class LoginEvent extends UserEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class LogoutEvent extends UserEvent {}

class GetUserProfileEvent extends UserEvent {} // Ensure this is defined

class UpdateUserProfileEvent extends UserEvent {
  final User user;

  UpdateUserProfileEvent(this.user);
}

class GetAllUsersEvent extends UserEvent {}

class DeleteUserEvent extends UserEvent {
  final int userId;

  DeleteUserEvent(this.userId);
}