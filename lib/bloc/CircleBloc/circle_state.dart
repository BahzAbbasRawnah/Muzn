import 'package:equatable/equatable.dart';
import 'package:muzn/models/circle_category_model.dart';
import 'package:muzn/models/circle_model.dart';
import 'package:muzn/models/school_model.dart';

abstract class CircleState extends Equatable {
  @override
  List<Object> get props => [];
}

class CircleInitial extends CircleState {}

class CircleLoading extends CircleState {}

class CirclesLoaded extends CircleState {
  final List<Circle> circles;
  CirclesLoaded(this.circles);
  @override
  List<Object> get props => [circles];
}

class CircleLoaded extends CircleState {
  final Circle circle;
  CircleLoaded(this.circle);
  @override
  List<Object> get props => [circle];
}

class CircleAdded extends CircleState {}

class CircleUpdated extends CircleState {}

class CircleDeleted extends CircleState {}

class CircleSoftDeleted extends CircleState {}

class CircleError extends CircleState {
  final String message;
  CircleError(this.message);
  @override
  List<Object> get props => [message];
}

// New state for categories
class CategoriesLoaded extends CircleState {
  final List<CirclesCategory> categories;
  CategoriesLoaded(this.categories);
  @override
  List<Object> get props => [categories];
}

// New state for schools
class SchoolsLoaded extends CircleState {
  final List<School> schools;
  SchoolsLoaded(this.schools);
  @override
  List<Object> get props => [schools];
}