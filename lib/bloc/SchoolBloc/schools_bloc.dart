import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/bloc/SchoolBloc/schools_event.dart';
import 'package:muzn/bloc/SchoolBloc/schools_state.dart';
import 'package:muzn/models/school_model.dart';
import 'package:muzn/controllers/school_controller.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolController _schoolController;
  SchoolBloc({required SchoolController schoolController})
      : _schoolController = schoolController,
        super(SchoolInitial()) {
    // Register event handlers
    on<AddSchoolEvent>(_onAddSchool);
    on<GetAllSchoolsEvent>(_onGetAllSchools);
    on<GetSchoolByIdEvent>(_onGetSchoolById);
    on<UpdateSchoolEvent>(_onUpdateSchool);
    on<DeleteSchoolEvent>(_onDeleteSchool);
    on<SoftDeleteSchoolEvent>(_onSoftDeleteSchool);
    on<GetSchoolsByTeacherIdEvent>(_onGetSchoolsByTeacherId); 
  }

  // Handler for AddSchoolEvent
  Future<void> _onAddSchool(AddSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      await _schoolController.addSchool(event.school);
      emit(SchoolAdded());
    } catch (e) {
      emit(SchoolError('Failed to add school: $e'));
    }
  }

  // Handler for GetAllSchoolsEvent
  Future<void> _onGetAllSchools(GetAllSchoolsEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      final schools = await _schoolController.getAllSchools();
      emit(SchoolsLoaded(schools));
    } catch (e) {
      emit(SchoolError('Failed to load schools: $e'));
    }
  }

  // Handler for GetSchoolsByTeacherIdEvent
  Future<void> _onGetSchoolsByTeacherId(GetSchoolsByTeacherIdEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      final schools = await _schoolController.getSchoolsByTeacherId(event.teacherId);
      emit(SchoolsLoaded(schools));
    } catch (e) {
      emit(SchoolError('Failed to fetch schools by teacher ID: $e'));
    }
  }

  // Handler for GetSchoolByIdEvent
  Future<void> _onGetSchoolById(GetSchoolByIdEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      final school = await _schoolController.getSchoolById(event.id);
      if (school != null) {
        emit(SchoolLoaded(school));
      } else {
        emit(SchoolError('School not found'));
      }
    } catch (e) {
      emit(SchoolError('Failed to load school: $e'));
    }
  }

  // Handler for UpdateSchoolEvent
  Future<void> _onUpdateSchool(UpdateSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      await _schoolController.updateSchool(event.school);

      // After updating, refresh schools for the specific teacher
      if (event.school.teacherId != null) {
        add(GetSchoolsByTeacherIdEvent(event.school.teacherId!));
      }

      emit(SchoolUpdated());
    } catch (e) {
      emit(SchoolError('Failed to update school: $e'));
    }
  }

  // Handler for DeleteSchoolEvent
  Future<void> _onDeleteSchool(DeleteSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      // Fetch the school details before deleting it
      final school = await _schoolController.getSchoolById(event.id);
      await _schoolController.deleteSchool(event.id);
      // After deleting, refresh schools for the specific teacher
      if (school?.teacherId != null) {
        add(GetSchoolsByTeacherIdEvent(school!.teacherId!));
      }

      emit(SchoolDeleted());
    } catch (e) {
      emit(SchoolError('Failed to delete school: $e'));
    }
  }

  // Handler for SoftDeleteSchoolEvent
  Future<void> _onSoftDeleteSchool(SoftDeleteSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      await _schoolController.softDeleteSchool(event.id);
      emit(SchoolSoftDeleted());
    } catch (e) {
      emit(SchoolError('Failed to soft delete school: $e'));
    }
  }
}