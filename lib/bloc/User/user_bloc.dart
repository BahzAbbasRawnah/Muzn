import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/bloc/User/user_event.dart';
import 'package:muzn/bloc/User/user_state.dart';
import 'package:muzn/controllers/user_controller.dart';
import 'package:muzn/models/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserController _userController;

  UserBloc({required UserController userController})
      : _userController = userController,
        super(UserInitial()) {
    // Initialize the user controller
    _userController.init().then((_) {
      // Initialization complete
      add(GetUserProfileEvent()); // Dispatch GetUserProfileEvent after initialization
    });

    // Register event handlers
    on<RegisterEvent>((event, emit) async {
      emit(UserLoading());
      bool isRegistered = await _userController.register(event.user);
      if (isRegistered) {
        emit(UserRegistered());
      } else {
        emit(UserError('Registration failed'));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(UserLoading());
      bool isLoggedIn = await _userController.login(event.email, event.password);
      if (isLoggedIn) {
        
        User? user = await _userController.getCurrentUser();
        if (user != null) {
          emit(UserAuthenticated(user));
        } else {
          emit(UserError('Failed to fetch user data'));
        }
      } else {
        emit(UserError('Invalid credentials'));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await _userController.logout();
      emit(UserUnauthenticated());
    });

    on<GetUserProfileEvent>((event, emit) async {
      emit(UserLoading());
      User? user =await _userController.getCurrentUser();
      if (user != null) {
        emit(UserAuthenticated(user)); // Emit the authenticated user state
      } else {
        emit(UserError('No user profile found')); // Emit an error state if no user is found
      }
    });

    on<UpdateUserProfileEvent>((event, emit) async {
      emit(UserLoading());
      bool isUpdated = await _userController.updateProfile(event.user);
      if (isUpdated) {
        emit(UserProfileUpdated());
      } else {
        emit(UserError('Failed to update profile'));
      }
    });

    on<GetAllUsersEvent>((event, emit) async {
      emit(UserLoading());
      List<User> users = await _userController.getAllUsers();
      emit(UsersLoaded(users));
    });

    on<DeleteUserEvent>((event, emit) async {
      emit(UserLoading());
      bool isDeleted = await _userController.deleteUser(event.userId);
      if (isDeleted) {
        emit(UserDeleted());
      } else {
        emit(UserError('Failed to delete user'));
      }
    });
  }
}