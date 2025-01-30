import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/bloc/SchoolBloc/school_repository.dart';
import 'package:muzn/bloc/SchoolBloc/schools_event.dart';
import 'package:muzn/bloc/SchoolBloc/schools_state.dart';


class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepository _repository;

  SchoolBloc(this._repository) : super(SchoolInitial()) {
    on<LoadSchools>((event, emit) async {
      emit(SchoolLoading());
      try {
        final schools = await _repository.fetchSchools(event.teacherId);
        emit(SchoolLoaded(schools: schools));
      } catch (e) {
        emit(SchoolError(message: e.toString()));
      }
    });

    on<AddSchoolEvent>((event, emit) async {
      try {
        await _repository.addSchool(event.school);
        emit(SchoolAdded());
      } catch (e) {
        emit(SchoolError(message: e.toString()));
      }
    });

    on<EditSchoolEvent>((event, emit) async {
      try {
        await _repository.editSchool(event.schoolId, event.updatedData);
        emit(SchoolEdited());
      } catch (e) {
        emit(SchoolError(message: e.toString()));
      }
    });

    on<DeleteSchoolEvent>((event, emit) async {
      try {
        await _repository.deleteSchool(event.schoolId);
        emit(SchoolDeleted());
      } catch (e) {
        emit(SchoolError(message: e.toString()));
      }
    });
  }
}
