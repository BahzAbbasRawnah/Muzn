import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/database_service.dart';
import '../../models/user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String emailOrPhone;
  final String password;

  LoginEvent({required this.emailOrPhone, required this.password});

  @override
  List<Object> get props => [emailOrPhone, password];
}

class RegisterEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String country;
  final String gender;

  RegisterEvent({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.country,
    required this.gender,
  });

  @override
  List<Object> get props => [fullName, email, password, phone, country, gender];
}

class UpdateProfileEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String country;
  final String gender;
  final String oldPassword;
  final String newPassword;

  UpdateProfileEvent({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.country,
    required this.gender,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [fullName, email, phone, country, gender, oldPassword, newPassword];
}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object> get props => [message];
}
class AuthUnauthenticated extends AuthState {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DatabaseManager _databaseManager = DatabaseManager();

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final db = await _databaseManager.database;
      final hashedPassword = _hashPassword(event.password);
      
      // Check if input is email or phone
      final bool isEmail = event.emailOrPhone.contains('@');
      
      // Query based on email or phone
      final List<Map<String, dynamic>> result = await db.query(
        'User',
        where: '${isEmail ? 'email' : 'phone'} = ? AND password = ? AND deleted_at IS NULL',
        whereArgs: [event.emailOrPhone, hashedPassword],
      );

      if (result.isNotEmpty) {
        final user = User.fromMap(result.first);
        if (user.status == 'active') {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError('account_inactive'));
        }
      } else {
        emit(AuthError('invalid_credentials'));
      }
    } catch (e) {
      emit(AuthError('login_failed'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final db = await _databaseManager.database;
      
      // Check if email already exists
      final List<Map<String, dynamic>> existingEmail = await db.query(
        'User',
        where: 'email = ? AND deleted_at IS NULL',
        whereArgs: [event.email],
      );

      if (existingEmail.isNotEmpty) {
        emit(AuthError('email_exists'));
        return;
      }

      // Check if phone already exists
      final List<Map<String, dynamic>> existingPhone = await db.query(
        'User',
        where: 'phone = ? AND deleted_at IS NULL',
        whereArgs: [event.phone],
      );

      if (existingPhone.isNotEmpty) {
        emit(AuthError('phone_exists'));
        return;
      }

      // Create new user
      final hashedPassword = _hashPassword(event.password);
      final now = DateTime.now().toIso8601String();
      
      final userId = await db.insert('User', {
        'full_name': event.fullName,
        'email': event.email,
        'password': hashedPassword,
        'phone': event.phone,
        'country': event.country,
        'gender': event.gender,
        'role': 'student', // Default role
        'status': 'active',
        'created_at': now,
        'updated_at': now,
      });

      final List<Map<String, dynamic>> newUser = await db.query(
        'User',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (newUser.isNotEmpty) {
        emit(AuthAuthenticated(User.fromMap(newUser.first)));
      } else {
        emit(AuthError('registration_failed'));
      }
    } catch (e) {
      emit(AuthError('registration_failed'));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthAuthenticated) {
      emit(AuthError('not_authenticated'));
      return;
    }

    emit(AuthLoading());
    try {
      final db = await _databaseManager.database;
      final currentUser = (state as AuthAuthenticated).user;
      
      // Verify old password if new password is provided
      if (event.newPassword.isNotEmpty) {
        final hashedOldPassword = _hashPassword(event.oldPassword);
        final List<Map<String, dynamic>> user = await db.query(
          'User',
          where: 'id = ? AND password = ?',
          whereArgs: [currentUser.id, hashedOldPassword],
        );

        if (user.isEmpty) {
          emit(AuthError('invalid_old_password'));
          return;
        }
      }

      // Update user data
      final updates = {
        'full_name': event.fullName,
        'email': event.email,
        'phone': event.phone,
        'country': event.country,
        'gender': event.gender,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (event.newPassword.isNotEmpty) {
        updates['password'] = _hashPassword(event.newPassword);
      }

      await db.update(
        'User',
        updates,
        where: 'id = ?',
        whereArgs: [currentUser.id],
      );

      final List<Map<String, dynamic>> updatedUser = await db.query(
        'User',
        where: 'id = ?',
        whereArgs: [currentUser.id],
      );

      if (updatedUser.isNotEmpty) {
        emit(AuthAuthenticated(User.fromMap(updatedUser.first)));
      } else {
        emit(AuthError('profile_update_failed'));
      }
    } catch (e) {
      emit(AuthError('profile_update_failed'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthUnauthenticated());
  }
}
