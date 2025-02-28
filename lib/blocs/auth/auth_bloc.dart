import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/app/core/check_if_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/core/get_user_id.dart';
import '../../app/core/secure_storage.dart';
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
  final String countryCode;
  final String gender;

  RegisterEvent({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.country,
    required this.gender,
    required this.countryCode,
  });

  @override
  List<Object> get props => [fullName, email, password, phone, country,countryCode, gender];
}

class UpdateProfileEvent extends AuthEvent {
  final User user;
  final String? newPassword;

  UpdateProfileEvent({required this.user, this.newPassword});

  @override
  List<Object> get props => [user, newPassword!];
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
  bool isLogin = false;
  int userId = 0;
  User? userModel;

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
    _getIsLogin();
    _getUserId();
    _getUserData();
    // isLogin=await checkIfLogin();
  }

  _getIsLogin() async {
    isLogin = await checkIfLogin();
  }

  _getUserId() async {
    userId = await getUserId();
  }

  _getUserData() async {
    final db = await _databaseManager.database;
    // final hashedPassword = _hashPassword(event.password);
    // final bool isEmail = event.emailOrPhone.contains('@');
userId=await getUserId();
// print("userId");
// print(userId);
    final List<Map<String, dynamic>> result = await db.query(
      'User',
      where: 'id= ? AND  deleted_at IS NULL',
      whereArgs: [userId],
    );
    print('on get user data ');
    print(result.toString());
    print('user id is ');
    print(userId);
    if (result.isNotEmpty) {
      final user = User.fromMap(result.first);
      userModel = user;
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setBool('authToken', true);
    }
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
      final bool isEmail = event.emailOrPhone.contains('@');

      final List<Map<String, dynamic>> result = await db.query(
        'User',
        where:
            '${isEmail ? 'email' : 'phone'} = ? AND password = ? AND deleted_at IS NULL',
        whereArgs: [event.emailOrPhone, hashedPassword],
      );

      if (result.isNotEmpty) {
        final user = User.fromMap(result.first);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('authToken', true);

        if (user.status == 'active') {
          final storage = SecureStorage();
          storage.write(key: 'isLogin', value: 'true');
          storage.write(key: 'user_id', value: user.id.toString());
          storage.write(key: 'user_name', value: user.fullName.toString());
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError('User is inactive'));
        }
      } else {
        emit(AuthError('Invalid email/phone or password'));
      }
    } catch (e) {
      emit(AuthError('Login failed: $e'));
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
        'country_code': event.countryCode,
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
        final storage = SecureStorage();
        var user=User.fromMap(newUser.first);
        storage.write(key: 'isLogin', value: 'true');
        storage.write(key: 'user_id', value: user.id.toString());
        storage.write(key: 'user_name', value: user.fullName.toString());
        _getIsLogin();
        _getUserId();
        _getUserData();
        emit(AuthAuthenticated(User.fromMap(newUser.first)));
      } else {
        emit(AuthError('registration_failed'));
      }
    } catch (e) {
      emit(AuthError('registration_failed'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<AuthState> emit) async {
    // Check if the user is authenticated
    if (state is! AuthAuthenticated) {
      emit(AuthError('not_authenticated'));
      return;
    }

    // Store the current user before emitting AuthLoading
    final currentUser = (state as AuthAuthenticated).user;

    emit(AuthLoading());

    try {
      final db = await _databaseManager.database;

      if (event.newPassword != null && event.newPassword!.isNotEmpty) {
        if (event.user.password == null || event.user.password!.isEmpty) {
          emit(AuthError('old_password_required'));
          return;
        }

        final hashedOldPassword = _hashPassword(event.user.password!);
        final List<Map<String, dynamic>> user = await db.query(
          'User',
          where: 'id = ? AND password = ?',
          whereArgs: [currentUser.id, hashedOldPassword],
        );

        if (user.isEmpty) {
          emit(AuthError('invalid_old_password'));
          return;
        } else {}
      }

      // Prepare updates for the user profile
      final updates = {
        'full_name': event.user.fullName,
        'email': event.user.email,
        'phone': event.user.phone,
        'country': event.user.country,
        'gender': event.user.gender,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Update password if a new one is provided
      if (event.newPassword != null && event.newPassword!.isNotEmpty) {
        final hashedNewPassword = _hashPassword(event.newPassword!);
        updates['password'] = hashedNewPassword;
      }

      // Perform the update in the database
      final rowsUpdated = await db.update(
        'User',
        updates,
        where: 'id = ?',
        whereArgs: [currentUser.id],
      );

      if (rowsUpdated > 0) {
        // Fetch the updated user data
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
      } else {
        emit(AuthError('profile_update_failed'));
      }
    } catch (e) {
      emit(AuthError('profile_update_failed'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      // Clear SharedPreferences
      final pref = await SharedPreferences.getInstance();
      await pref.remove('authToken'); // Remove the authentication token
      await pref.clear(); // Optionally, clear all stored data

      // Reset the state to unauthenticated
      emit(AuthUnauthenticated());
    } catch (e) {
      // Handle any errors during logout
      emit(AuthError('Logout failed: $e'));
    }
  }
}
