import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/models/circle_category.dart';
import 'package:muzn/services/database_service.dart';

// Events
abstract class CircleCategoryEvent extends Equatable {
  final BuildContext context;
  const CircleCategoryEvent(this.context);

  @override
  List<Object> get props => [context];
}

class LoadCircleCategories extends CircleCategoryEvent {
  const LoadCircleCategories(BuildContext context) : super(context);
}

// States
abstract class CircleCategoryState extends Equatable {
  const CircleCategoryState();

  @override
  List<Object> get props => [];
}

class CircleCategoryInitial extends CircleCategoryState {}

class CircleCategoryLoading extends CircleCategoryState {}

class CircleCategoriesLoaded extends CircleCategoryState {
  final List<CircleCategory> categories;

  const CircleCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CircleCategoryError extends CircleCategoryState {
  final String message;

  const CircleCategoryError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class CircleCategoryBloc extends Bloc<CircleCategoryEvent, CircleCategoryState> {
  final DatabaseManager _databaseManager = DatabaseManager();

  CircleCategoryBloc() : super(CircleCategoryInitial()) {
    on<LoadCircleCategories>(_onLoadCircleCategories);
  }

  Future<void> _onLoadCircleCategories(
    LoadCircleCategories event,
    Emitter<CircleCategoryState> emit,
  ) async {
    emit(CircleCategoryLoading());
    try {
      final db = await _databaseManager.database;
      
      final results = await db.query(
        'CirclesCategory',
        where: 'deleted_at IS NULL',
        orderBy: 'name',
      );

      emit(CircleCategoriesLoaded(
        results.map((row) => CircleCategory.fromMap(row)).toList(),
      ));
    } catch (e) {
      emit(CircleCategoryError(e.toString()));
    }
  }
}
