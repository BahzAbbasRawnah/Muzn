import 'package:equatable/equatable.dart';

abstract class CircleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CircleInitial extends CircleState {}

class CircleLoading extends CircleState {}

class CircleLoaded extends CircleState {
  final List<Map<String, dynamic>> circles;
  CircleLoaded({required this.circles});
}

class CircleError extends CircleState {
  final String message;
  CircleError({required this.message});
}

class CircleAdded extends CircleState {}

class CircleEdited extends CircleState {}

class CircleDeleted extends CircleState {}
