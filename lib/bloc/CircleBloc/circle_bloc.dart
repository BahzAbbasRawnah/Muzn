import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/bloc/CircleBloc/circle_event.dart';
import 'package:muzn/bloc/CircleBloc/circle_state.dart';
import 'package:muzn/repository/category_repository.dart';
import 'package:muzn/repository/circle_repository.dart';
import 'package:muzn/repository/school_repository.dart';

class CircleBloc extends Bloc<CircleEvent, CircleState> {
  // Create an instance of CircleRepository internally
  final CircleRepository _circleRepository = CircleRepository();
  final CirclesCategoryRepository _categoryRepository = CirclesCategoryRepository();
  final SchoolRepository _schoolRepository = SchoolRepository();

  CircleBloc() : super(CircleInitial()) {
    on<AddCircleEvent>(_onAddCircle);
    on<GetAllCirclesEvent>(_onGetAllCircles);
    on<GetCirclesBySchoolIdEvent>(_onGetCirclesBySchoolId);
    on<GetCircleByIdEvent>(_onGetCircleById);
    on<UpdateCircleEvent>(_onUpdateCircle);
    on<SoftDeleteCircleEvent>(_onSoftDeleteCircle);
    on<DeleteCircleEvent>(_onDeleteCircle);
    on<GetCategoriesEvent>(_onGetCategories); // Handle GetCategoriesEvent
    on<GetSchoolsEvent>(_onGetSchools); // Handle GetSchoolsEvent
  }

  // Add a new circle
  Future<void> _onAddCircle(AddCircleEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      await _circleRepository.addCircle(event.circle);
      emit(CircleAdded());
    } catch (e) {
      emit(CircleError('Failed to add circle: $e'));
    }
  }

  // Get all circles
  Future<void> _onGetAllCircles(GetAllCirclesEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final circles = await _circleRepository.getAllCircles();
      emit(CirclesLoaded(circles));
    } catch (e) {
      emit(CircleError('Failed to load circles: $e'));
    }
  }

  // Get circles by school ID
  Future<void> _onGetCirclesBySchoolId(GetCirclesBySchoolIdEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final circles = await _circleRepository.getCirclesBySchoolId(event.schoolId);
      emit(CirclesLoaded(circles));
    } catch (e) {
      emit(CircleError('Failed to load circles for school ID ${event.schoolId}: $e'));
    }
  }

  // Get a single circle by ID
  Future<void> _onGetCircleById(GetCircleByIdEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final circle = await _circleRepository.getCircleById(event.id);
      if (circle != null) {
        emit(CircleLoaded(circle));
      } else {
        emit(CircleError('Circle not found'));
      }
    } catch (e) {
      emit(CircleError('Failed to fetch circle: $e'));
    }
  }

  // Update a circle
  Future<void> _onUpdateCircle(UpdateCircleEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      await _circleRepository.updateCircle(event.circle);
      emit(CircleUpdated());
    } catch (e) {
      emit(CircleError('Failed to update circle: $e'));
    }
  }

  // Soft delete a circle (mark as deleted)
  Future<void> _onSoftDeleteCircle(SoftDeleteCircleEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      await _circleRepository.softDeleteCircle(event.id);
      final updatedCircles = await _circleRepository.getCirclesBySchoolId(event.schoolId);
      emit(CirclesLoaded(updatedCircles));
    } catch (e) {
      emit(CircleError('Failed to soft delete circle: $e'));
    }
  }

  // Permanently delete a circle
  Future<void> _onDeleteCircle(DeleteCircleEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      await _circleRepository.deleteCircle(event.id);
      final updatedCircles = await _circleRepository.getCirclesBySchoolId(event.schoolId);
      emit(CirclesLoaded(updatedCircles));
    } catch (e) {
      emit(CircleError('Failed to delete circle: $e'));
    }
  }

  // Fetch categories
  Future<void> _onGetCategories(GetCategoriesEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final categories = await _categoryRepository.fetchCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CircleError('Failed to load categories: $e'));
    }
  }

  // Fetch schools
  Future<void> _onGetSchools(GetSchoolsEvent event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final schools = await _schoolRepository.getAllSchools();
      emit(SchoolsLoaded(schools));
    } catch (e) {
      emit(CircleError('Failed to load schools: $e'));
    }
  }
}